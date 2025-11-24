import 'package:cloud_firestore/cloud_firestore.dart';

class FarmOptionModel {
  final String id;
  final String type; // 'crop_type' or 'status'
  final String value; // The actual value (e.g., 'Padi', 'preparing')
  final String label; // Display label (e.g., 'Padi', 'Persiapan')
  final int order; // Order for sorting
  final bool isActive; // Whether option is active/visible
  final int? color; // Optional color value for status

  FarmOptionModel({
    required this.id,
    required this.type,
    required this.value,
    required this.label,
    required this.order,
    this.isActive = true,
    this.color,
  });

  static FarmOptionModel empty() => FarmOptionModel(
    id: '',
    type: '',
    value: '',
    label: '',
    order: 0,
    isActive: false,
  );

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'label': label,
      'order': order,
      'is_active': isActive,
      'color': color,
    };
  }

  factory FarmOptionModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() == null) return FarmOptionModel.empty();
    
    final data = snapshot.data()!;
    return FarmOptionModel(
      id: snapshot.id,
      type: data['type'] ?? '',
      value: data['value'] ?? '',
      label: data['label'] ?? '',
      order: data['order'] ?? 0,
      isActive: data['is_active'] ?? true,
      color: data['color'],
    );
  }

  factory FarmOptionModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return FarmOptionModel(
      id: id ?? '',
      type: json['type'] ?? '',
      value: json['value'] ?? '',
      label: json['label'] ?? '',
      order: json['order'] ?? 0,
      isActive: json['is_active'] ?? true,
      color: json['color'],
    );
  }
}

