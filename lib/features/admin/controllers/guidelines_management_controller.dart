import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/detection/models/guideline_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class GuidelinesManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final guidelines = <GuidelineModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadGuidelines();
  }

  /// Load all guidelines
  Future<void> loadGuidelines() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading guidelines...');

      final snapshot = await _db.collection('Guidelines').orderBy('order').get();

      guidelines.assignAll(
        snapshot.docs.map((doc) => GuidelineModel.fromSnapshot(doc)).toList(),
      );

      TLoggerHelper.info('Loaded ${guidelines.length} guidelines');
    } catch (e) {
      TLoggerHelper.error('Error loading guidelines', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat panduan: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered guidelines based on search query
  List<GuidelineModel> get filteredGuidelines {
    if (searchQuery.value.isEmpty) {
      return guidelines;
    }
    final query = searchQuery.value.toLowerCase();
    return guidelines.where((guideline) {
      return guideline.title.toLowerCase().contains(query) ||
          guideline.description.toLowerCase().contains(query);
    }).toList();
  }

  /// Create guideline
  Future<void> createGuideline(GuidelineModel guideline) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Creating guideline: ${guideline.title}');

      await _db.collection('Guidelines').add(guideline.toJson());

      await loadGuidelines();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Panduan berhasil dibuat',
      );
    } catch (e) {
      TLoggerHelper.error('Error creating guideline', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal membuat panduan: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update guideline
  Future<void> updateGuideline(String docId, GuidelineModel guideline) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Updating guideline: $docId');

      await _db.collection('Guidelines').doc(docId).update(guideline.toJson());

      await loadGuidelines();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Panduan berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating guideline', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui panduan: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete guideline
  Future<void> deleteGuideline(String docId) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Deleting guideline: $docId');

      await _db.collection('Guidelines').doc(docId).delete();

      await loadGuidelines();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Panduan berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting guideline', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus panduan: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }
}

