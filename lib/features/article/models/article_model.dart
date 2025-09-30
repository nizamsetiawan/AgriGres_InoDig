import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  String category;
  String title;
  String content;
  String author;
  String createdAt;
  String imageUrl;

  ArticleModel(
      {required this.title,
      required this.category,
      required this.imageUrl,
      required this.author,
      required this.content,
      required this.createdAt});

  static ArticleModel empty() => ArticleModel(
      title: '',
      category: '',
      imageUrl: '',
      author: '',
      content: '',
      createdAt: '');

  toJson() {
    return {
      'category': category,
      'title': title,
      'content': content,
      'author': author,
      'created_at': createdAt,
      'image_url': imageUrl,
    };
  }

  factory ArticleModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ArticleModel.empty();
    return ArticleModel(
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      content: data['content'] ?? '',
      author:  data ['author'] ?? '',
      createdAt: data ['created_at'] ?? '',
      imageUrl:  data ['image_url'] ?? ''
    );
  }

  factory ArticleModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() != null) {
      final data = snapshot.data()!;
      return ArticleModel(
          title: data['title'] ?? '',
          category: data['category'] ?? '',
          content: data['content'] ?? '',
          author:  data ['author'] ?? '',
          createdAt: data ['created_at'] ?? '',
          imageUrl:  data ['image_url'] ?? ''
      );
    } else {
      return ArticleModel.empty();
    }
  }

  //from query snapshot
  factory ArticleModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return ArticleModel(
        title: data['title'] ?? '',
        category: data['category'] ?? '',
        content: data['content'] ?? '',
        author:  data ['author'] ?? '',
        createdAt: data ['created_at'] ?? '',
        imageUrl:  data ['image_url'] ?? ''
    );
  }
}
