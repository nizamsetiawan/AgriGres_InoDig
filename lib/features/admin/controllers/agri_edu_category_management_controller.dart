import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/agri_edu/models/agri_edu_category_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class AgriEduCategoryManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final categories = <AgriEduCategoryModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  /// Load all categories
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading AgriEdu categories...');

      final snapshot = await _db.collection('AgriEduCategories').orderBy('order').get();

      categories.assignAll(
        snapshot.docs.map((doc) => AgriEduCategoryModel.fromSnapshot(doc)).toList(),
      );

      TLoggerHelper.info('Loaded ${categories.length} categories');
    } catch (e) {
      TLoggerHelper.error('Error loading categories', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat kategori: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered categories based on search query
  List<AgriEduCategoryModel> get filteredCategories {
    if (searchQuery.value.isEmpty) {
      return categories;
    }
    final query = searchQuery.value.toLowerCase();
    return categories.where((category) {
      return category.name.toLowerCase().contains(query);
    }).toList();
  }

  /// Create category
  Future<void> createCategory(AgriEduCategoryModel category) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Creating category: ${category.name}');

      await _db.collection('AgriEduCategories').add(category.toJson());

      await loadCategories();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Kategori berhasil dibuat',
      );
    } catch (e) {
      TLoggerHelper.error('Error creating category', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal membuat kategori: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update category
  Future<void> updateCategory(String docId, AgriEduCategoryModel category) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Updating category: $docId');

      await _db.collection('AgriEduCategories').doc(docId).update(category.toJson());

      await loadCategories();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Kategori berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating category', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui kategori: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete category
  Future<void> deleteCategory(String docId) async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Deleting category: $docId');

      await _db.collection('AgriEduCategories').doc(docId).delete();

      await loadCategories();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Kategori berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting category', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus kategori: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }
}

