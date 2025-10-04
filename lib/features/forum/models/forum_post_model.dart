import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPostModel {
  String id;
  String userId;
  String userName;
  String userImageUrl;
  String content;
  String? imageUrl;
  List<String>? imageUrls;
  String? location;
  bool isAnonymous;
  bool disableComments;
  List<String> likes;
  List<ForumCommentModel> comments;
  DateTime createdAt;
  DateTime updatedAt;

  ForumPostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.content,
    this.imageUrl,
    this.imageUrls,
    this.location,
    this.isAnonymous = false,
    this.disableComments = false,
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  static ForumPostModel empty() => ForumPostModel(
    id: '',
    userId: '',
    userName: '',
    userImageUrl: '',
    content: '',
    likes: [],
    comments: [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_image_url': userImageUrl,
      'content': content,
      'image_url': imageUrl,
      'image_urls': imageUrls,
      'location': location,
      'is_anonymous': isAnonymous,
      'disable_comments': disableComments,
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ForumPostModel.fromJson(Map<String, dynamic> json) {
    return ForumPostModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userImageUrl: json['user_image_url'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      imageUrls: json['image_urls'] != null ? List<String>.from(json['image_urls']) : null,
      location: json['location'],
      isAnonymous: json['is_anonymous'] ?? false,
      disableComments: json['disable_comments'] ?? false,
      likes: List<String>.from(json['likes'] ?? []),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((comment) => ForumCommentModel.fromJson(comment))
          .toList() ?? [],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  factory ForumPostModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() != null) {
      final data = snapshot.data()!;
      return ForumPostModel(
        id: snapshot.id,
        userId: data['user_id'] ?? '',
        userName: data['user_name'] ?? '',
        userImageUrl: data['user_image_url'] ?? '',
        content: data['content'] ?? '',
        imageUrl: data['image_url'],
        imageUrls: data['image_urls'] != null ? List<String>.from(data['image_urls']) : null,
        location: data['location'],
        isAnonymous: data['is_anonymous'] ?? false,
        disableComments: data['disable_comments'] ?? false,
        likes: List<String>.from(data['likes'] ?? []),
        comments: (data['comments'] as List<dynamic>?)
            ?.map((comment) => ForumCommentModel.fromJson(comment))
            .toList() ?? [],
        createdAt: DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(data['updated_at'] ?? '') ?? DateTime.now(),
      );
    } else {
      return ForumPostModel.empty();
    }
  }

  ForumPostModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userImageUrl,
    String? content,
    String? imageUrl,
    List<String>? imageUrls,
    String? location,
    bool? isAnonymous,
    bool? disableComments,
    List<String>? likes,
    List<ForumCommentModel>? comments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ForumPostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location ?? this.location,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      disableComments: disableComments ?? this.disableComments,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ForumCommentModel {
  String id;
  String userId;
  String userName;
  String userImageUrl;
  String content;
  DateTime createdAt;

  ForumCommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_image_url': userImageUrl,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ForumCommentModel.fromJson(Map<String, dynamic> json) {
    return ForumCommentModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userImageUrl: json['user_image_url'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
