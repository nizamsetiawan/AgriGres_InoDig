import 'package:agrigres/data/repositories/favorite_articles/favorite_articles_repository.dart';
import 'package:agrigres/features/article/models/favorite_article_model.dart';
import 'package:agrigres/features/article/models/article_model.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/loaders.dart';
import '../../../utils/logging/logger.dart';

class FavoriteArticlesController extends GetxController {
  static FavoriteArticlesController get instance => Get.find();

  final favoriteArticlesRepository = Get.put(FavoriteArticlesRepository());

  RxBool isLoading = false.obs;
  final RxList<FavoriteArticleModel> favoriteArticles = <FavoriteArticleModel>[].obs;
  final RxMap<String, bool> favoriteStatus = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't load automatically - only load when needed
  }

  // Load all favorite articles
  Future<void> loadFavoriteArticles() async {
    try {
      TLoggerHelper.info('Loading favorite articles...');
      isLoading.value = true;

      final favorites = await favoriteArticlesRepository.getFavoriteArticles();
      favoriteArticles.assignAll(favorites);

      // Update favorite status map
      for (var favorite in favorites) {
        favoriteStatus[favorite.articleId] = true;
      }

      TLoggerHelper.info('Loaded ${favorites.length} favorite articles');
    } catch (e) {
      TLoggerHelper.error('Error loading favorite articles', e);
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Add article to favorites
  Future<void> addToFavorites(ArticleModel article) async {
    try {
      TLoggerHelper.info('Adding article to favorites: ${article.title}');
      
      await favoriteArticlesRepository.addToFavorites(article);
      
      // Update local state
      final favoriteArticle = FavoriteArticleModel.fromArticleModel(
        userId: '', // Will be set by repository
        article: article,
      );
      favoriteArticles.add(favoriteArticle);
      favoriteStatus[article.title] = true;
      
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Artikel ditambahkan ke favorit',
      );
    } catch (e) {
      TLoggerHelper.error('Error adding to favorites', e);
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Remove article from favorites
  Future<void> removeFromFavorites(String articleId) async {
    try {
      TLoggerHelper.info('Removing article from favorites: $articleId');
      
      await favoriteArticlesRepository.removeFromFavorites(articleId);
      
      // Update local state
      favoriteArticles.removeWhere((fav) => fav.articleId == articleId);
      favoriteStatus[articleId] = false;
      
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Artikel dihapus dari favorit',
      );
    } catch (e) {
      TLoggerHelper.error('Error removing from favorites', e);
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(ArticleModel article) async {
    final isFavorite = favoriteStatus[article.title] ?? false;
    
    if (isFavorite) {
      await removeFromFavorites(article.title);
    } else {
      await addToFavorites(article);
    }
  }

  // Check if article is favorite
  bool isFavorite(String articleId) {
    return favoriteStatus[articleId] ?? false;
  }

  // Check if article is favorite (async version for real-time check)
  Future<bool> isFavoriteAsync(String articleId) async {
    try {
      return await favoriteArticlesRepository.isFavorite(articleId);
    } catch (e) {
      TLoggerHelper.error('Error checking favorite status', e);
      return false;
    }
  }

  // Get favorite articles as ArticleModel list
  List<ArticleModel> get favoriteArticlesAsArticleModel {
    return favoriteArticles.map((fav) => fav.toArticleModel()).toList();
  }

  // Clear all favorites (for logout)
  void clearFavorites() {
    favoriteArticles.clear();
    favoriteStatus.clear();
  }
}
