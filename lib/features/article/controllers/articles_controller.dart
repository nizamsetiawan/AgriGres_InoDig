import 'package:agrigres/data/repositories/articles/articles_repository.dart';
import 'package:agrigres/features/article/models/article_model.dart';
import 'package:agrigres/features/detection/controllers/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/loaders.dart';
import '../../../utils/logging/logger.dart';

class ArticleController extends GetxController {
  static ArticleController get instance => Get.find();

  RxBool isLoading = true.obs;
  final RxList<ArticleModel> allArticles = <ArticleModel>[].obs;
  final RxList<ArticleModel> categoryArticles = <ArticleModel>[].obs;
  final RxList<ArticleModel> filteredArticles = <ArticleModel>[].obs;

  final articlesRepository = Get.put(ArticlesRepository());
  final categoryController = Get.put(CategoryController());
  final RxString selectedCategory = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'Semua'.obs;
  
  // Text controllers
  final searchController = TextEditingController();
  
  // Get categories from CategoryController
  List<String> get categories {
    List<String> categoryList = ['Semua'];
    if (categoryController.allCategories.isNotEmpty) {
      categoryList.addAll(
        categoryController.allCategories
            .where((category) => category.parentId.isEmpty) // Only parent categories
            .map((category) => category.name)
            .toList()
      );
    }
    return categoryList;
  }

  // @override
  // void onInit() {
  //   fetchAllArticles();
  //   super.onInit();
  // }
  void fetchAllArticles() async {
    try {
      TLoggerHelper.info('Fetching featured articles...');

      isLoading.value = true;

      final articles = await articlesRepository.getAllArticles();

      TLoggerHelper.info(
          'Fetched featured articles: ${articles.length} articles');

      allArticles.assignAll(articles);
      applyFilters(); // Apply current filters after fetching
    } catch (e) {
      TLoggerHelper.error('Error while fetching featured articles', e);
      TLoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void fetchArticlesByCategory(String category) async {
    try {
      isLoading.value = true;
      selectedCategory.value = category;

      final articles = await articlesRepository.getArticlesByCategory(category);
      categoryArticles.assignAll(articles);

      TLoggerHelper.info('Fetched ${articles.length} articles for category: $category');
    } catch (e) {
      TLoggerHelper.error('Error while fetching articles by category', e);
      TLoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Search functionality
  void searchArticles(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  // Filter by category
  void filterByCategory(String category) {
    selectedFilter.value = category;
    applyFilters();
  }

  // Apply both search and filter
  void applyFilters() async {
    List<ArticleModel> filtered = List.from(allArticles);

    // Apply category filter first (fetch from repository if needed)
    if (selectedFilter.value != 'Semua') {
      try {
        // Fetch articles by category from repository
        final categoryArticles = await articlesRepository.getArticlesByCategory(selectedFilter.value);
        filtered = categoryArticles;
      } catch (e) {
        TLoggerHelper.error('Error fetching articles by category', e);
        // Fallback to local filtering
        filtered = allArticles.where((article) {
          return article.category.toLowerCase() == selectedFilter.value.toLowerCase();
        }).toList();
      }
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((article) {
        return article.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               article.content.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               article.author.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    filteredArticles.assignAll(filtered);
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    applyFilters();
  }

  // Clear all filters
  void clearAllFilters() {
    searchController.clear();
    searchQuery.value = '';
    selectedFilter.value = 'Semua';
    applyFilters();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

}
