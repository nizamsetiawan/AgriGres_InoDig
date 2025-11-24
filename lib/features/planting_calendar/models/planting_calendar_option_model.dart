import 'package:cloud_firestore/cloud_firestore.dart';

class PlantingCalendarOptionModel {
  final String id;
  final String value; // The actual value (e.g., 'Padi')
  final String label; // Display label (e.g., 'Padi')
  final int order; // Order for sorting
  final bool isActive; // Whether option is active/visible

  PlantingCalendarOptionModel({
    required this.id,
    required this.value,
    required this.label,
    required this.order,
    this.isActive = true,
  });

  static PlantingCalendarOptionModel empty() => PlantingCalendarOptionModel(
    id: '',
    value: '',
    label: '',
    order: 0,
    isActive: false,
  );

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
      'order': order,
      'is_active': isActive,
    };
  }

  factory PlantingCalendarOptionModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() == null) return PlantingCalendarOptionModel.empty();
    
    final data = snapshot.data()!;
    return PlantingCalendarOptionModel(
      id: snapshot.id,
      value: data['value'] ?? '',
      label: data['label'] ?? '',
      order: data['order'] ?? 0,
      isActive: data['is_active'] ?? true,
    );
  }

  factory PlantingCalendarOptionModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return PlantingCalendarOptionModel(
      id: id ?? '',
      value: json['value'] ?? '',
      label: json['label'] ?? '',
      order: json['order'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}

