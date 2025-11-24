import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/planting_calendar/models/planting_calendar_option_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class PlantingCalendarOptionManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final options = <PlantingCalendarOptionModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadOptions();
  }

  /// Load all options
  Future<void> loadOptions() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading planting calendar options...');

      final snapshot = await _db.collection('PlantingCalendarOptions').orderBy('order').get();

      options.assignAll(
        snapshot.docs.map((doc) => PlantingCalendarOptionModel.fromSnapshot(doc)).toList(),
      );

      TLoggerHelper.info('Loaded ${options.length} planting calendar options');
    } catch (e) {
      TLoggerHelper.error('Error loading planting calendar options', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat opsi: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered options based on search query
  List<PlantingCalendarOptionModel> get filteredOptions {
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
  Future<void> createOption(PlantingCalendarOptionModel option) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Creating option: ${option.label}');

      await _db.collection('PlantingCalendarOptions').add(option.toJson());

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
  Future<void> updateOption(String docId, PlantingCalendarOptionModel option) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Updating option: $docId');

      await _db.collection('PlantingCalendarOptions').doc(docId).update(option.toJson());

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

      await _db.collection('PlantingCalendarOptions').doc(docId).delete();

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

