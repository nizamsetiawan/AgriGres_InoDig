import 'package:agrigres/data/repositories/articles/articles_repository.dart';
import 'package:agrigres/features/article/models/article_model.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/loaders.dart';
import '../../../utils/logging/logger.dart';

class ArticleController extends GetxController {
  static ArticleController get instance => Get.find();

  RxBool isLoading = true.obs;
  final RxList<ArticleModel> allArticles = <ArticleModel>[].obs;
  final RxList<ArticleModel> categoryArticles = <ArticleModel>[].obs;

  final articlesRepository = Get.put(ArticlesRepository());
  final RxString selectedCategory = ''.obs;

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

}
