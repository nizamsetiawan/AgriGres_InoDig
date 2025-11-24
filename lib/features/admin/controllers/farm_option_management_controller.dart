import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/farm_management/models/farm_option_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class FarmOptionManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final options = <FarmOptionModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedType = 'crop_type'.obs; // 'crop_type' or 'status'

  @override
  void onInit() {
    super.onInit();
    loadOptions();
  }

  /// Load all options
  Future<void> loadOptions() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading farm options...');

      final snapshot = await _db
          .collection('FarmOptions')
          .where('type', isEqualTo: selectedType.value)
          .orderBy('order')
          .get();

      options.assignAll(
        snapshot.docs.map((doc) => FarmOptionModel.fromSnapshot(doc)).toList(),
      );

      TLoggerHelper.info('Loaded ${options.length} farm options');
    } catch (e) {
      TLoggerHelper.error('Error loading farm options', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat opsi: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Switch between crop types and status options
  void switchType(String type) {
    selectedType.value = type;
    loadOptions();
  }

  /// Get filtered options based on search query
  List<FarmOptionModel> get filteredOptions {
    if (searchQuery.value.isEmpty) {
      return options;
    }
    final query = searchQuery.value.toLowerCase();
    return options.where((option) {
      return option.value.toLowerCase().contains(query) ||
          option.label.toLowerCase().contains(query);
    }).toList();
  }

  /// Create option
  Future<void> createOption(FarmOptionModel option) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Creating option: ${option.label}');

      await _db.collection('FarmOptions').add(option.toJson());

      await loadOptions();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Opsi berhasil dibuat',
      );
    } catch (e) {
      TLoggerHelper.error('Error creating option', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal membuat opsi: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update option
  Future<void> updateOption(String docId, FarmOptionModel option) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Updating option: $docId');

      await _db.collection('FarmOptions').doc(docId).update(option.toJson());

      await loadOptions();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Opsi berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating option', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui opsi: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete option
  Future<void> deleteOption(String docId) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Deleting option: $docId');

      await _db.collection('FarmOptions').doc(docId).delete();

      await loadOptions();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Opsi berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting option', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus opsi: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }
}

