import 'package:cloud_firestore/cloud_firestore.dart';

class LevelHargaOptionModel {
  final String id;
  final int levelId; // The ID used in API (1, 2, 3, etc.)
  final String name; // Display name (e.g., 'Produsen')
  final int order; // Order for sorting
  final bool isActive; // Whether option is active/visible

  LevelHargaOptionModel({
    required this.id,
    required this.levelId,
    required this.name,
    required this.order,
    this.isActive = true,
  });

  static LevelHargaOptionModel empty() => LevelHargaOptionModel(
    id: '',
    levelId: 0,
    name: '',
    order: 0,
    isActive: false,
  );

  Map<String, dynamic> toJson() {
    return {
      'level_id': levelId,
      'name': name,
      'order': order,
      'is_active': isActive,
    };
  }

  factory LevelHargaOptionModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() == null) return LevelHargaOptionModel.empty();
    
    final data = snapshot.data()!;
    return LevelHargaOptionModel(
      id: snapshot.id,
      levelId: data['level_id'] ?? 0,
      name: data['name'] ?? '',
      order: data['order'] ?? 0,
      isActive: data['is_active'] ?? true,
    );
  }

  factory LevelHargaOptionModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return LevelHargaOptionModel(
      id: id ?? '',
      levelId: json['level_id'] ?? 0,
      name: json['name'] ?? '',
      order: json['order'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }

  /// Convert to Map format used in controllers
  Map<String, dynamic> toControllerMap() {
    return {
      'id': levelId,
      'name': name,
    };
  }
}

