import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing farm/land management data
class FarmModel {
  final String id;
  final String userId; // Owner of the farm
  final String farmName; // Nama lahan
  final double area; // Luas lahan (hektar)
  final String location; // Lokasi lahan
  final String? address; // Alamat lengkap
  final String cropType; // Jenis tanaman yang ditanam
  final String? cropVariety; // Varietas tanaman
  final DateTime? plantingDate; // Tanggal tanam
  final DateTime? expectedHarvestDate; // Estimasi tanggal panen
  final String status; // 'preparing', 'planting', 'growing', 'harvesting', 'harvested'
  final String? notes; // Catatan tambahan
  final List<String> imageUrls; // Foto-foto lahan
  final DateTime createdAt;
  final DateTime updatedAt;

  FarmModel({
    required this.id,
    required this.userId,
    required this.farmName,
    required this.area,
    required this.location,
    this.address,
    required this.cropType,
    this.cropVariety,
    this.plantingDate,
    this.expectedHarvestDate,
    this.status = 'preparing',
    this.notes,
    this.imageUrls = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Static function to create an empty farm model
  static FarmModel empty() => FarmModel(
        id: '',
        userId: '',
        farmName: '',
        area: 0.0,
        location: '',
        cropType: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  /// Convert model to json structure for storing data in firebase
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'farm_name': farmName,
      'area': area,
      'location': location,
      'address': address,
      'crop_type': cropType,
      'crop_variety': cropVariety,
      'planting_date': plantingDate?.toIso8601String(),
      'expected_harvest_date': expectedHarvestDate?.toIso8601String(),
      'status': status,
      'notes': notes,
      'image_urls': imageUrls,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Factory method to create a farm model from a firebase document snapshot.
  factory FarmModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return FarmModel(
        id: document.id,
        userId: data['user_id'] ?? '',
        farmName: data['farm_name'] ?? '',
        area: (data['area'] ?? 0.0).toDouble(),
        location: data['location'] ?? '',
        address: data['address'],
        cropType: data['crop_type'] ?? '',
        cropVariety: data['crop_variety'],
        plantingDate: data['planting_date'] != null
            ? DateTime.parse(data['planting_date'])
            : null,
        expectedHarvestDate: data['expected_harvest_date'] != null
            ? DateTime.parse(data['expected_harvest_date'])
            : null,
        status: data['status'] ?? 'preparing',
        notes: data['notes'],
        imageUrls: List<String>.from(data['image_urls'] ?? []),
        createdAt: data['created_at'] != null
            ? DateTime.parse(data['created_at'])
            : DateTime.now(),
        updatedAt: data['updated_at'] != null
            ? DateTime.parse(data['updated_at'])
            : DateTime.now(),
      );
    } else {
      return FarmModel.empty();
    }
  }

  /// Factory method to create from query snapshot
  factory FarmModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return FarmModel(
      id: document.id,
      userId: data['user_id'] ?? '',
      farmName: data['farm_name'] ?? '',
      area: (data['area'] ?? 0.0).toDouble(),
      location: data['location'] ?? '',
      address: data['address'],
      cropType: data['crop_type'] ?? '',
      cropVariety: data['crop_variety'],
      plantingDate: data['planting_date'] != null
          ? DateTime.parse(data['planting_date'])
          : null,
      expectedHarvestDate: data['expected_harvest_date'] != null
          ? DateTime.parse(data['expected_harvest_date'])
          : null,
      status: data['status'] ?? 'preparing',
      notes: data['notes'],
      imageUrls: List<String>.from(data['image_urls'] ?? []),
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : DateTime.now(),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'])
          : DateTime.now(),
    );
  }

  /// Copy with method for updating fields
  FarmModel copyWith({
    String? id,
    String? userId,
    String? farmName,
    double? area,
    String? location,
    String? address,
    String? cropType,
    String? cropVariety,
    DateTime? plantingDate,
    DateTime? expectedHarvestDate,
    String? status,
    String? notes,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FarmModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      farmName: farmName ?? this.farmName,
      area: area ?? this.area,
      location: location ?? this.location,
      address: address ?? this.address,
      cropType: cropType ?? this.cropType,
      cropVariety: cropVariety ?? this.cropVariety,
      plantingDate: plantingDate ?? this.plantingDate,
      expectedHarvestDate: expectedHarvestDate ?? this.expectedHarvestDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get status label in Indonesian
  String get statusLabel {
    switch (status) {
      case 'preparing':
        return 'Persiapan';
      case 'planting':
        return 'Menanam';
      case 'growing':
        return 'Tumbuh';
      case 'harvesting':
        return 'Panen';
      case 'harvested':
        return 'Sudah Panen';
      default:
        return status;
    }
  }

  /// Get status color
  int get statusColor {
    switch (status) {
      case 'preparing':
        return 0xFF9E9E9E; // Grey
      case 'planting':
        return 0xFF2196F3; // Blue
      case 'growing':
        return 0xFF4CAF50; // Green
      case 'harvesting':
        return 0xFFFF9800; // Orange
      case 'harvested':
        return 0xFF8BC34A; // Light Green
      default:
        return 0xFF9E9E9E;
    }
  }
}

