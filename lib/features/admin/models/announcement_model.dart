import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing announcement data
class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final String type; // 'announcement', 'update', 'feature'
  final bool isActive;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String createdBy; // Admin email or name

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.type = 'announcement',
    this.isActive = true,
    required this.createdAt,
    this.expiresAt,
    required this.createdBy,
  });

  /// Static function to create an empty announcement model
  static AnnouncementModel empty() => AnnouncementModel(
        id: '',
        title: '',
        content: '',
        createdAt: DateTime.now(),
        createdBy: '',
        isActive: false,
      );

  /// Convert model to json structure for storing data in firebase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'type': type,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'created_by': createdBy,
    };
  }

  /// Factory method to create an announcement model from a firebase document snapshot.
  factory AnnouncementModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return AnnouncementModel(
        id: document.id,
        title: data['title'] ?? '',
        content: data['content'] ?? '',
        imageUrl: data['image_url'],
        type: data['type'] ?? 'announcement',
        isActive: data['is_active'] ?? true,
        createdAt: data['created_at'] != null
            ? DateTime.parse(data['created_at'])
            : DateTime.now(),
        expiresAt: data['expires_at'] != null
            ? DateTime.parse(data['expires_at'])
            : null,
        createdBy: data['created_by'] ?? '',
      );
    } else {
      return AnnouncementModel.empty();
    }
  }

  /// Factory method to create from query snapshot
  factory AnnouncementModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return AnnouncementModel(
      id: document.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['image_url'],
      type: data['type'] ?? 'announcement',
      isActive: data['is_active'] ?? true,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : DateTime.now(),
      expiresAt: data['expires_at'] != null
          ? DateTime.parse(data['expires_at'])
          : null,
      createdBy: data['created_by'] ?? '',
    );
  }

  /// Copy with method for updating fields
  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    String? type,
    bool? isActive,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? createdBy,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  /// Check if announcement is still valid (not expired)
  bool get isValid {
    if (!isActive) return false;
    if (expiresAt == null) return true;
    return DateTime.now().isBefore(expiresAt!);
  }
}

