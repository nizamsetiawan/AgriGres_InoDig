import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/detection/models/result_analyze_model.dart';
import 'package:agrigres/data/repositories/categories/category_repository.dart';
import 'package:agrigres/data/repositories/disease/model_repository.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class AnalyzeManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final categoryRepository = Get.find<CategoryRepository>();
  final modelRepository = Get.find<ModelRepository>();

  final analyzes = <ResultAnalyzeModel>[].obs;
  final analyzeDocIds = <String, String>{}.obs; // Map label to document ID
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  
  // Available labels from all DetectionConfig
  final availableLabels = <String>[].obs;
  // Available categories from Categories collection
  final availableCategories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAnalyzes();
    loadAvailableLabels();
    loadAvailableCategories();
  }

  /// Load all available labels from DetectionConfig
  Future<void> loadAvailableLabels() async {
    try {
      TLoggerHelper.info('Loading available labels from DetectionConfig...');
      
      final allLabels = <String>{};
      
      // Get all plant types
      final plantTypes = await modelRepository.getAvailablePlantTypes();
      
      // Load config for each plant type and collect all labels
      for (final plantType in plantTypes) {
        try {
          final doc = await _db.collection('DetectionConfig').doc(plantType).get();
          if (doc.exists && doc.data() != null) {
            final data = doc.data()!;
            final labels = (data['labels'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ?? [];
            allLabels.addAll(labels);
          }
        } catch (e) {
          TLoggerHelper.error('Error loading labels for $plantType', e);
        }
      }
      
      // Sort labels alphabetically
      final sortedLabels = allLabels.toList()..sort();
      availableLabels.assignAll(sortedLabels);
      
      TLoggerHelper.info('Loaded ${availableLabels.length} available labels');
    } catch (e) {
      TLoggerHelper.error('Error loading available labels', e);
    }
  }

  /// Load all available categories from Categories collection
  Future<void> loadAvailableCategories() async {
    try {
      TLoggerHelper.info('Loading available categories...');
      
      final categories = await categoryRepository.getAllCategories();
      final categoryNames = categories
          .map((c) => c.name)
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList()
        ..sort();
      
      availableCategories.assignAll(categoryNames);
      
      TLoggerHelper.info('Loaded ${availableCategories.length} available categories');
    } catch (e) {
      TLoggerHelper.error('Error loading available categories', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat kategori: ${e.toString()}',
      );
    }
  }

  /// Load all analyzes
  Future<void> loadAnalyzes() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading analyzes...');

      final snapshot = await _db.collection('Analyze').orderBy('label').get();

      analyzeDocIds.clear();
      analyzes.assignAll(
        snapshot.docs.map((doc) {
          final data = doc.data();
          final label = data['label'] ?? '';
          // Store document ID mapped to label
          if (label.isNotEmpty) {
            analyzeDocIds[label] = doc.id;
          }
          return ResultAnalyzeModel(
            gejala: data['gejala'] ?? '',
            kategori: data['kategori'] ?? '',
            label: label,
            pencegahan: data['pencegahan'] ?? '',
            pengendalianHayati: data['pengendalian_hayati'] ?? '',
            pengendalianKimiawi: data['pengendalian_kimiawi'] ?? '',
            penyebab: data['penyebab'] ?? '',
            imagePath: data['imagePath'] ?? '',
            probability: data['probability'] ?? '',
          );
        }).toList(),
      );

      TLoggerHelper.info('Loaded ${analyzes.length} analyzes');
    } catch (e) {
      TLoggerHelper.error('Error loading analyzes', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat data analisis: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered analyzes based on search query
  List<ResultAnalyzeModel> get filteredAnalyzes {
    if (searchQuery.value.isEmpty) {
      return analyzes;
    }
    final query = searchQuery.value.toLowerCase();
    return analyzes.where((analyze) {
      return analyze.label.toLowerCase().contains(query) ||
          analyze.kategori.toLowerCase().contains(query) ||
          analyze.gejala.toLowerCase().contains(query);
    }).toList();
  }

  /// Create analyze
  Future<void> createAnalyze(ResultAnalyzeModel analyze) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Creating analyze: ${analyze.label}');

      await _db.collection('Analyze').add({
        'label': analyze.label,
        'kategori': analyze.kategori,
        'gejala': analyze.gejala,
        'penyebab': analyze.penyebab,
        'pencegahan': analyze.pencegahan,
        'pengendalian_hayati': analyze.pengendalianHayati,
        'pengendalian_kimiawi': analyze.pengendalianKimiawi,
        'imagePath': analyze.imagePath,
        'probability': analyze.probability,
      });

      await loadAnalyzes();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Data analisis berhasil dibuat',
      );
    } catch (e) {
      TLoggerHelper.error('Error creating analyze', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal membuat data analisis: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update analyze
  Future<void> updateAnalyze(String docId, ResultAnalyzeModel analyze) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Updating analyze: $docId');

      await _db.collection('Analyze').doc(docId).update({
        'label': analyze.label,
        'kategori': analyze.kategori,
        'gejala': analyze.gejala,
        'penyebab': analyze.penyebab,
        'pencegahan': analyze.pencegahan,
        'pengendalian_hayati': analyze.pengendalianHayati,
        'pengendalian_kimiawi': analyze.pengendalianKimiawi,
        'imagePath': analyze.imagePath,
        'probability': analyze.probability,
      });

      await loadAnalyzes();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Data analisis berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating analyze', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui data analisis: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete analyze
  Future<void> deleteAnalyze(String docId) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Deleting analyze: $docId');

      await _db.collection('Analyze').doc(docId).delete();

      await loadAnalyzes();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Data analisis berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting analyze', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus data analisis: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get analyze by document ID
  Future<ResultAnalyzeModel?> getAnalyzeById(String docId) async {
    try {
      final doc = await _db.collection('Analyze').doc(docId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return ResultAnalyzeModel(
          gejala: data['gejala'] ?? '',
          kategori: data['kategori'] ?? '',
          label: data['label'] ?? '',
          pencegahan: data['pencegahan'] ?? '',
          pengendalianHayati: data['pengendalian_hayati'] ?? '',
          pengendalianKimiawi: data['pengendalian_kimiawi'] ?? '',
          penyebab: data['penyebab'] ?? '',
          imagePath: data['imagePath'] ?? '',
          probability: data['probability'] ?? '',
        );
      }
      return null;
    } catch (e) {
      TLoggerHelper.error('Error getting analyze by ID', e);
      return null;
    }
  }

  /// Get document ID by label
  Future<String?> getAnalyzeByLabel(String label) async {
    try {
      // Check cache first
      if (analyzeDocIds.containsKey(label)) {
        return analyzeDocIds[label];
      }
      
      // If not in cache, fetch from Firebase
      final snapshot = await _db
          .collection('Analyze')
          .where('label', isEqualTo: label)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs.first.id;
        analyzeDocIds[label] = docId;
        return docId;
      }
      return null;
    } catch (e) {
      TLoggerHelper.error('Error getting analyze by label', e);
      return null;
    }
  }

  /// Delete analyze by label
  Future<void> deleteAnalyzeByLabel(String label) async {
    try {
      final docId = await getAnalyzeByLabel(label);
      if (docId != null) {
        await deleteAnalyze(docId);
        // Remove from cache
        analyzeDocIds.remove(label);
      } else {
        TLoaders.errorSnackBar(
          title: 'Kesalahan',
          message: 'Data tidak ditemukan',
        );
      }
    } catch (e) {
      TLoggerHelper.error('Error deleting analyze by label', e);
    }
  }
}

