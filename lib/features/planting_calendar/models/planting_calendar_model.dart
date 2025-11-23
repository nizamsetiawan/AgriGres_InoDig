import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing planting calendar data
class PlantingCalendarModel {
  final String id;
  final String cropName; // Nama tanaman/komoditas
  final String cropType; // Jenis tanaman (padi, jagung, sayuran, dll)
  final String plantingMonth; // Bulan tanam (1-12 atau nama bulan)
  final String harvestMonth; // Bulan panen
  final int plantingDuration; // Durasi tanam dalam hari
  final String location; // Lokasi (Gresik, Jawa Timur, dll)
  final String description; // Deskripsi
  final List<String> recommendedVarieties; // Varietas yang direkomendasikan
  final List<String> careTips; // Tips perawatan
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final String createdBy;

  PlantingCalendarModel({
    required this.id,
    required this.cropName,
    required this.cropType,
    required this.plantingMonth,
    required this.harvestMonth,
    required this.plantingDuration,
    required this.location,
    required this.description,
    this.recommendedVarieties = const [],
    this.careTips = const [],
    this.imageUrl,
    this.isActive = true,
    required this.createdAt,
    required this.createdBy,
  });

  /// Static function to create an empty planting calendar model
  static PlantingCalendarModel empty() => PlantingCalendarModel(
        id: '',
        cropName: '',
        cropType: '',
        plantingMonth: '',
        harvestMonth: '',
        plantingDuration: 0,
        location: '',
        description: '',
        createdAt: DateTime.now(),
        createdBy: '',
        isActive: false,
      );

  /// Convert model to json structure for storing data in firebase
  Map<String, dynamic> toJson() {
    return {
      'crop_name': cropName,
      'crop_type': cropType,
      'planting_month': plantingMonth,
      'harvest_month': harvestMonth,
      'planting_duration': plantingDuration,
      'location': location,
      'description': description,
      'recommended_varieties': recommendedVarieties,
      'care_tips': careTips,
      'image_url': imageUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
    };
  }

  /// Factory method to create a planting calendar model from a firebase document snapshot.
  factory PlantingCalendarModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return PlantingCalendarModel(
        id: document.id,
        cropName: data['crop_name'] ?? '',
        cropType: data['crop_type'] ?? '',
        plantingMonth: data['planting_month'] ?? '',
        harvestMonth: data['harvest_month'] ?? '',
        plantingDuration: data['planting_duration'] ?? 0,
        location: data['location'] ?? '',
        description: data['description'] ?? '',
        recommendedVarieties: List<String>.from(data['recommended_varieties'] ?? []),
        careTips: List<String>.from(data['care_tips'] ?? []),
        imageUrl: data['image_url'],
        isActive: data['is_active'] ?? true,
        createdAt: data['created_at'] != null
            ? DateTime.parse(data['created_at'])
            : DateTime.now(),
        createdBy: data['created_by'] ?? '',
      );
    } else {
      return PlantingCalendarModel.empty();
    }
  }

  /// Factory method to create from query snapshot
  factory PlantingCalendarModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return PlantingCalendarModel(
      id: document.id,
      cropName: data['crop_name'] ?? '',
      cropType: data['crop_type'] ?? '',
      plantingMonth: data['planting_month'] ?? '',
      harvestMonth: data['harvest_month'] ?? '',
      plantingDuration: data['planting_duration'] ?? 0,
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      recommendedVarieties: List<String>.from(data['recommended_varieties'] ?? []),
      careTips: List<String>.from(data['care_tips'] ?? []),
      imageUrl: data['image_url'],
      isActive: data['is_active'] ?? true,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : DateTime.now(),
      createdBy: data['created_by'] ?? '',
    );
  }

  /// Copy with method for updating fields
  PlantingCalendarModel copyWith({
    String? id,
    String? cropName,
    String? cropType,
    String? plantingMonth,
    String? harvestMonth,
    int? plantingDuration,
    String? location,
    String? description,
    List<String>? recommendedVarieties,
    List<String>? careTips,
    String? imageUrl,
    bool? isActive,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return PlantingCalendarModel(
      id: id ?? this.id,
      cropName: cropName ?? this.cropName,
      cropType: cropType ?? this.cropType,
      plantingMonth: plantingMonth ?? this.plantingMonth,
      harvestMonth: harvestMonth ?? this.harvestMonth,
      plantingDuration: plantingDuration ?? this.plantingDuration,
      location: location ?? this.location,
      description: description ?? this.description,
      recommendedVarieties: recommendedVarieties ?? this.recommendedVarieties,
      careTips: careTips ?? this.careTips,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}

