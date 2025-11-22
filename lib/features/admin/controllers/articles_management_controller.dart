import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/article/models/article_model.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/logging/logger.dart';

class ArticlesManagementController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final articles = <ArticleModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadArticles();
  }

  /// Load all articles
  /// Uses Firestore Document ID as the primary identifier
  Future<void> loadArticles() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading articles...');

      final snapshot = await _db.collection('Articles').get();

      // fromSnapshot automatically extracts Document ID from snapshot.id
      articles.assignAll(
        snapshot.docs.map((doc) => ArticleModel.fromSnapshot(doc)).toList(),
      );

      TLoggerHelper.info('Loaded ${articles.length} articles');
    } catch (e) {
      TLoggerHelper.error('Error loading articles', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memuat artikel: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered articles based on search query
  List<ArticleModel> get filteredArticles {
    if (searchQuery.value.isEmpty) {
      return articles;
    }
    return articles.where((article) {
      final query = searchQuery.value.toLowerCase();
      return article.title.toLowerCase().contains(query) ||
          article.content.toLowerCase().contains(query) ||
          article.category.toLowerCase().contains(query) ||
          article.author.toLowerCase().contains(query);
    }).toList();
  }

  /// Delete article by Document ID
  /// @param articleId - Firestore Document ID (not title or other field)
  Future<void> deleteArticle(String articleId) async {
    try {
      TLoggerHelper.info('Deleting article with Document ID: $articleId');

      // Delete using Firestore Document ID
      await _db.collection('Articles').doc(articleId).delete();

      // Remove from local list using Document ID
      articles.removeWhere((article) => article.id == articleId);

      // Reload to ensure consistency
      await loadArticles();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Artikel berhasil dihapus',
      );
    } catch (e) {
      TLoggerHelper.error('Error deleting article', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menghapus artikel: ${e.toString()}',
      );
    }
  }

  /// Update article by Document ID
  /// @param docId - Firestore Document ID (not title or other field)
  /// @param article - Updated article data
  Future<void> updateArticle(String docId, ArticleModel article) async {
    try {
      TLoggerHelper.info('Updating article with Document ID: $docId');

      // Create updated article with correct Document ID
      final updatedArticle = ArticleModel(
        id: docId, // Preserve Firestore Document ID
        title: article.title,
        category: article.category,
        imageUrl: article.imageUrl,
        author: article.author,
        content: article.content,
        createdAt: article.createdAt,
      );

      // Update using Firestore Document ID
      await _db.collection('Articles').doc(docId).update(updatedArticle.toJson());

      // Update local list using Document ID
      final index = articles.indexWhere((a) => a.id == docId);
      if (index != -1) {
        articles[index] = updatedArticle;
      }

      // Reload to ensure consistency
      await loadArticles();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Artikel berhasil diperbarui',
      );
    } catch (e) {
      TLoggerHelper.error('Error updating article', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal memperbarui artikel: ${e.toString()}',
      );
    }
  }

  /// Create article
  /// Firestore will auto-generate a Document ID
  Future<void> createArticle(ArticleModel article) async {
    try {
      TLoggerHelper.info('Creating article: ${article.title}');

      // Firestore auto-generates Document ID when using .add()
      final docRef = await _db.collection('Articles').add(article.toJson());

      // Create article with the auto-generated Firestore Document ID
      final createdArticle = ArticleModel(
        id: docRef.id, // Use Firestore Document ID
        title: article.title,
        category: article.category,
        imageUrl: article.imageUrl,
        author: article.author,
        content: article.content,
        createdAt: article.createdAt,
      );

      articles.add(createdArticle);

      // Reload to ensure consistency
      await loadArticles();

      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Artikel berhasil dibuat',
      );
    } catch (e) {
      TLoggerHelper.error('Error creating article', e);
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal membuat artikel: ${e.toString()}',
      );
    }
  }
}

