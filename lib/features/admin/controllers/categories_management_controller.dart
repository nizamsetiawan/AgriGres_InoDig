import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/detection/models/category_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class CategoriesManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final categories = <CategoryModel>[].obs;
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
      TLoggerHelper.info('Loading categories...');

      final snapshot = await _db.collection('Categories').get();

      categories.assignAll(
        snapshot.docs.map((doc) => CategoryModel.fromSnapshot(doc)).toList(),
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
  List<CategoryModel> get filteredCategories {
    if (searchQuery.value.isEmpty) {
      return categories;
    }
    return categories.where((category) {
      final query = searchQuery.value.toLowerCase();
      return category.name.toLowerCase().contains(query);
    }).toList();
  }

  /// Create category
  Future<void> createCategory(CategoryModel category) async {
    try {
      TLoggerHelper.info('Creating category: ${category.name}');

      final docRef = await _db.collection('Categories').add(category.toJson());

      final createdCategory = CategoryModel(
        id: docRef.id,
        name: category.name,
        image: category.image,
        parentId: category.parentId,
        isFeatured: category.isFeatured,
      );

      categories.add(createdCategory);

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
    }
  }

  /// Update category
  Future<void> updateCategory(String docId, CategoryModel category) async {
    try {
      TLoggerHelper.info('Updating category: $docId');

      final updatedCategory = CategoryModel(
        id: docId,
        name: category.name,
        image: category.image,
        parentId: category.parentId,
        isFeatured: category.isFeatured,
      );

      await _db.collection('Categories').doc(docId).update(updatedCategory.toJson());

      final index = categories.indexWhere((c) => c.id == docId);
      if (index != -1) {
        categories[index] = updatedCategory;
      }

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
    }
  }

  /// Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      TLoggerHelper.info('Deleting category: $categoryId');

      await _db.collection('Categories').doc(categoryId).delete();

      categories.removeWhere((category) => category.id == categoryId);

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
    }
  }
}

