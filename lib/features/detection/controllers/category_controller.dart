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
        TLoggerHelper.debug( 'Name: ${category.name}, Image URL: ${category.image}');
      }

      //update the categories list
      allCategories.assignAll(categories);

      //filter featured categories
      featuredCategories.assignAll(allCategories.where((category) => category.isFeatured && category.parentId.isEmpty).take(8).toList());

    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
    }finally{
      //remove loader
      isLoading.value = false;
    }
  }

}