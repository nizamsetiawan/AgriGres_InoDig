import 'package:agrigres/utils/logging/logger.dart';
import 'package:get/get.dart';
import 'package:agrigres/data/repositories/categories/category_repository.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

import '../models/category_model.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  /// -- load category data
  Future<void> fetchCategories() async {
    try{
      //show loader while loading categories
      isLoading.value = true;

      //fetch categories from data source(firestore,api,etc)
      final categories = await _categoryRepository.getAllCategories();

      TLoggerHelper.info('Successfully fetched ${categories.length} categories');

      for (var category in categories) {
        TLoggerHelper.debug( 'Name: ${category.name}, Image URL: ${category.image}, Featured: ${category.isFeatured}, ParentId: ${category.parentId}');
      }

      //update the categories list
      allCategories.assignAll(categories);

      //filter featured categories - show up to 10 categories
      final featuredCats = allCategories.where((category) => category.isFeatured && category.parentId.isEmpty).toList();
      final parentCats = allCategories.where((category) => category.parentId.isEmpty).toList();
      
      TLoggerHelper.info('Featured categories: ${featuredCats.length}');
      TLoggerHelper.info('Parent categories: ${parentCats.length}');
      
      if (featuredCats.length >= 10) {
        // If we have 10+ featured categories, take first 10
        featuredCategories.assignAll(featuredCats.take(10).toList());
        TLoggerHelper.info('Using ${featuredCategories.length} featured categories');
      } else {
        // If we have less than 10 featured categories, fill with non-featured parent categories
        final nonFeaturedCats = allCategories.where((category) => !category.isFeatured && category.parentId.isEmpty).toList();
        final combinedCats = [...featuredCats, ...nonFeaturedCats];
        featuredCategories.assignAll(combinedCats.take(10).toList());
        TLoggerHelper.info('Using ${featuredCategories.length} combined categories (${featuredCats.length} featured + ${nonFeaturedCats.length} non-featured)');
      }
      
      TLoggerHelper.info('Final featured categories count: ${featuredCategories.length}');

    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
    }finally{
      //remove loader
      isLoading.value = false;
    }
  }

}