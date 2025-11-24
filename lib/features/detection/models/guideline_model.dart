import 'package:cloud_firestore/cloud_firestore.dart';

class GuidelineModel {
  final String id;
  final String title;
  final String description;
  final String? icon; // Optional icon/emoji
  final int order; // Order for sorting
  final bool isActive; // Whether guideline is active/visible

  GuidelineModel({
    required this.id,
    required this.title,
    required this.description,
    this.icon,
    required this.order,
    this.isActive = true,
  });

  static GuidelineModel empty() => GuidelineModel(
    id: '',
    title: '',
    description: '',
    order: 0,
    isActive: false,
  );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'order': order,
      'is_active': isActive,
    };
  }

  factory GuidelineModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() == null) return GuidelineModel.empty();
    
    final data = snapshot.data()!;
    return GuidelineModel(
      id: snapshot.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'],
      order: data['order'] ?? 0,
      isActive: data['is_active'] ?? true,
    );
  }

  factory GuidelineModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return GuidelineModel(
      id: id ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'],
      order: json['order'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}

