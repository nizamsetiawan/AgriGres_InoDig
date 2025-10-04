import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrigres/features/article/models/article_model.dart';

class FavoriteArticleModel {
  String id;
  String userId;
  String articleId;
  String articleTitle;
  String articleContent;
  String articleAuthor;
  String articleCategory;
  String articleImageUrl;
  String articleCreatedAt;
  DateTime addedAt;

  FavoriteArticleModel({
    required this.id,
    required this.userId,
    required this.articleId,
    required this.articleTitle,
    required this.articleContent,
    required this.articleAuthor,
    required this.articleCategory,
    required this.articleImageUrl,
    required this.articleCreatedAt,
    required this.addedAt,
  });

  static FavoriteArticleModel empty() => FavoriteArticleModel(
    id: '',
    userId: '',
    articleId: '',
    articleTitle: '',
    articleContent: '',
    articleAuthor: '',
    articleCategory: '',
    articleImageUrl: '',
    articleCreatedAt: '',
    addedAt: DateTime.now(),
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'article_id': articleId,
      'article_title': articleTitle,
      'article_content': articleContent,
      'article_author': articleAuthor,
      'article_category': articleCategory,
      'article_image_url': articleImageUrl,
      'article_created_at': articleCreatedAt,
      'added_at': addedAt.toIso8601String(),
    };
  }

  factory FavoriteArticleModel.fromJson(Map<String, dynamic> json) {
    return FavoriteArticleModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      articleId: json['article_id'] ?? '',
      articleTitle: json['article_title'] ?? '',
      articleContent: json['article_content'] ?? '',
      articleAuthor: json['article_author'] ?? '',
      articleCategory: json['article_category'] ?? '',
      articleImageUrl: json['article_image_url'] ?? '',
      articleCreatedAt: json['article_created_at'] ?? '',
      addedAt: DateTime.tryParse(json['added_at'] ?? '') ?? DateTime.now(),
    );
  }

  factory FavoriteArticleModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() != null) {
      final data = snapshot.data()!;
      return FavoriteArticleModel(
        id: snapshot.id,
        userId: data['user_id'] ?? '',
        articleId: data['article_id'] ?? '',
        articleTitle: data['article_title'] ?? '',
        articleContent: data['article_content'] ?? '',
        articleAuthor: data['article_author'] ?? '',
        articleCategory: data['article_category'] ?? '',
        articleImageUrl: data['article_image_url'] ?? '',
        articleCreatedAt: data['article_created_at'] ?? '',
        addedAt: DateTime.tryParse(data['added_at'] ?? '') ?? DateTime.now(),
      );
    } else {
      return FavoriteArticleModel.empty();
    }
  }

  // Convert to ArticleModel for display
  ArticleModel toArticleModel() {
    return ArticleModel(
      title: articleTitle,
      category: articleCategory,
      imageUrl: articleImageUrl,
      author: articleAuthor,
      content: articleContent,
      createdAt: articleCreatedAt,
    );
  }

  // Create from ArticleModel
  factory FavoriteArticleModel.fromArticleModel({
    required String userId,
    required ArticleModel article,
  }) {
    return FavoriteArticleModel(
      id: '',
      userId: userId,
      articleId: article.title, // Using title as unique identifier
      articleTitle: article.title,
      articleContent: article.content,
      articleAuthor: article.author,
      articleCategory: article.category,
      articleImageUrl: article.imageUrl,
      articleCreatedAt: article.createdAt,
      addedAt: DateTime.now(),
    );
  }
}
