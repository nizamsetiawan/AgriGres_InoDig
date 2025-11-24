import 'package:cloud_firestore/cloud_firestore.dart';

class AgriEduCategoryModel {
  final String id;
  final String name;
  final int order; // Order for sorting
  final bool isActive; // Whether category is active/visible

  AgriEduCategoryModel({
    required this.id,
    required this.name,
    required this.order,
    this.isActive = true,
  });

  static AgriEduCategoryModel empty() => AgriEduCategoryModel(
    id: '',
    name: '',
    order: 0,
    isActive: false,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'order': order,
      'is_active': isActive,
    };
  }

  factory AgriEduCategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() == null) return AgriEduCategoryModel.empty();
    
    final data = snapshot.data()!;
    return AgriEduCategoryModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      order: data['order'] ?? 0,
      isActive: data['is_active'] ?? true,
    );
  }

  factory AgriEduCategoryModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return AgriEduCategoryModel(
      id: id ?? '',
      name: json['name'] ?? '',
      order: json['order'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}

