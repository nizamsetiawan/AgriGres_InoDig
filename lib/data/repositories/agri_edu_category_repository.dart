import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrigres/features/agri_edu/models/agri_edu_category_model.dart';
import 'package:agrigres/utils/logging/logger.dart';

class AgriEduCategoryRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get all active categories
  Future<List<AgriEduCategoryModel>> getCategories() async {
    try {
      TLoggerHelper.info('Fetching AgriEdu categories from Firebase...');

      final snapshot = await _db
          .collection('AgriEduCategories')
          .where('is_active', isEqualTo: true)
          .orderBy('order')
          .get();

      final categories = snapshot.docs
          .map((doc) => AgriEduCategoryModel.fromSnapshot(doc))
          .where((category) => category.name.isNotEmpty)
          .toList();

      TLoggerHelper.info('Loaded ${categories.length} AgriEdu categories from Firebase');

      // If no categories found, return default
      if (categories.isEmpty) {
        return _getDefaultCategories();
      }

      return categories;
    } catch (e) {
      TLoggerHelper.error('Error fetching AgriEdu categories from Firebase', e);
      // Return default categories on error
      return _getDefaultCategories();
    }
  }

  /// Get default categories (fallback)
  List<AgriEduCategoryModel> _getDefaultCategories() {
    TLoggerHelper.info('Using default AgriEdu categories');
    return [
      AgriEduCategoryModel(id: 'pertanian', name: 'Pertanian', order: 1, isActive: true),
      AgriEduCategoryModel(id: 'hidroponik', name: 'Hidroponik', order: 2, isActive: true),
      AgriEduCategoryModel(id: 'organik', name: 'Organik', order: 3, isActive: true),
      AgriEduCategoryModel(id: 'urban', name: 'Urban', order: 4, isActive: true),
      AgriEduCategoryModel(id: 'aquaponik', name: 'Aquaponik', order: 5, isActive: true),
      AgriEduCategoryModel(id: 'teknologi', name: 'Teknologi', order: 6, isActive: true),
      AgriEduCategoryModel(id: 'tips', name: 'Tips', order: 7, isActive: true),
      AgriEduCategoryModel(id: 'greenhouse', name: 'Greenhouse', order: 8, isActive: true),
      AgriEduCategoryModel(id: 'pascapanen', name: 'Pascapanen', order: 9, isActive: true),
    ];
  }
}

