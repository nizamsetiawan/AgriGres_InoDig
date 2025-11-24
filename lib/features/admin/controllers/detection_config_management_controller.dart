import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/data/repositories/disease/model_repository.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class DetectionConfigModel {
  final String plantType;
  final List<String> labels;
  final String? customKeyword;

  DetectionConfigModel({
    required this.plantType,
    required this.labels,
    this.customKeyword,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'labels': labels,
    };
    if (customKeyword != null && customKeyword!.isNotEmpty) {
      json['keyword'] = customKeyword;
    }
    return json;
  }

  factory DetectionConfigModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DetectionConfigModel(
      plantType: doc.id,
      labels: (data['labels'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ?? [],
      customKeyword: data['keyword'] as String?,
    );
  }
}

class DetectionConfigManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final modelRepository = Get.find<ModelRepository>();

  final configs = <DetectionConfigModel>[].obs;
  final isLoading = false.obs;

  // Default plant types
  static const List<String> defaultPlantTypes = [
    'Tanaman Tomat',
    'Tanaman Singkong',
    'Tanaman Jagung',
  ];

  @override
  void onInit() {
    super.onInit();
    loadConfigs();
  }

  /// Load all detection configs
  Future<void> loadConfigs() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading detection configs...');

      final loadedConfigs = <DetectionConfigModel>[];

      // Load all documents from DetectionConfig collection
      final snapshot = await _db.collection('DetectionConfig').get();
      
      // Add all configs from Firebase
      for (final doc in snapshot.docs) {
        if (doc.exists) {
          loadedConfigs.add(DetectionConfigModel.fromFirestore(doc));
        }
      }

      // Ensure default plant types exist (create if not in Firebase)
      for (final plantType in defaultPlantTypes) {
        final exists = loadedConfigs.any((c) => c.plantType == plantType);
        if (!exists) {
          // Create default config if not exists
          loadedConfigs.add(DetectionConfigModel(
            plantType: plantType,
            labels: _getDefaultLabels(plantType),
          ));
        }
      }

      // Sort by plant type name
      loadedConfigs.sort((a, b) => a.plantType.compareTo(b.plantType));

      configs.assignAll(loadedConfigs);
      TLoggerHelper.info('Loaded ${configs.length} detection configs');
    } catch (e) {
      TLoggerHelper.error('Error loading detection configs', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat konfigurasi: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get default labels for plant type
  List<String> _getDefaultLabels(String plantType) {
    if (plantType == 'Tanaman Tomat') {
      return [
        'Late Blight (Busuk Daun)',
        'Septoria Leaf Spot (Bercak Daun Septoria)',
        'Leaf Mold (Daun Berjamur)',
        'Target Spot (Bintik Target)',
        'Tomat Sehat',
        'Early Blight (Bercak Daun)',
        'Bacterial Spot',
        'Yellow Leaf Curl Virus (TYLCV)',
        'Two-Spot Spider Mite (Tungau Laba-laba)',
      ];
    } else if (plantType == 'Tanaman Singkong') {
      return [
        'Cassava Mosaic Disease',
        'Cassava Brown Streak Disease',
        'Singkong Sehat',
        'Cassava Green Mite',
        'Mosaic Virus',
        'Cassava Bacterial Blight',
      ];
    } else if (plantType == 'Tanaman Jagung') {
      return [
        'Jagung Sehat',
        'Northern Leaf Blight (Hawar Daun Utara)',
        'Common Rust (Karat Daun)',
        'Gray Leaf Spot (Bintik Abu-abu Daun)',
      ];
    }
    return [];
  }

  /// Update detection config
  Future<void> updateConfig(DetectionConfigModel config) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Updating detection config: ${config.plantType}');

      await _db.collection('DetectionConfig').doc(config.plantType).set(
        config.toJson(),
        SetOptions(merge: false),
      );

      // Update local cache
      final index = configs.indexWhere((c) => c.plantType == config.plantType);
      if (index != -1) {
        configs[index] = config;
      } else {
        configs.add(config);
      }

      // Clear cache in ModelRepository
      modelRepository.clearDetectionConfigCache();

      await loadConfigs();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Konfigurasi berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating detection config', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui konfigurasi: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get config by plant type
  DetectionConfigModel? getConfigByPlantType(String plantType) {
    try {
      return configs.firstWhere((c) => c.plantType == plantType);
    } catch (e) {
      return null;
    }
  }

  /// Create new detection config
  Future<void> createConfig(DetectionConfigModel config) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Creating detection config: ${config.plantType}');

      // Check if already exists
      final existing = configs.any((c) => c.plantType == config.plantType);
      if (existing) {
        TLoaders.errorSnackBar(
          title: 'Kesalahan',
          message: 'Tanaman "${config.plantType}" sudah ada',
        );
        return;
      }

      await _db.collection('DetectionConfig').doc(config.plantType).set(
        config.toJson(),
        SetOptions(merge: false),
      );

      // Add to local list
      configs.add(config);
      configs.sort((a, b) => a.plantType.compareTo(b.plantType));

      // Clear cache in ModelRepository
      modelRepository.clearDetectionConfigCache();

      await loadConfigs();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Tanaman baru berhasil ditambahkan',
      );
    } catch (e) {
      TLoggerHelper.error('Error creating detection config', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menambahkan tanaman: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete detection config
  Future<void> deleteConfig(String plantType) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Deleting detection config: $plantType');

      // Prevent deleting default plant types
      if (defaultPlantTypes.contains(plantType)) {
        TLoaders.errorSnackBar(
          title: 'Kesalahan',
          message: 'Tanaman default tidak dapat dihapus',
        );
        return;
      }

      await _db.collection('DetectionConfig').doc(plantType).delete();

      configs.removeWhere((c) => c.plantType == plantType);

      // Clear cache in ModelRepository
      modelRepository.clearDetectionConfigCache();

      await loadConfigs();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Tanaman berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting detection config', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus tanaman: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }
}

