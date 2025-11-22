import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing admin data
class AdminModel {
  final String id;
  final String email;
  final String name;
  final String role; // 'admin' or 'super_admin'
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;

  /// Constructor for AdminModel
  AdminModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    this.lastLoginAt,
    this.isActive = true,
  });

  /// Static function to create an empty admin model
  static AdminModel empty() => AdminModel(
        id: '',
        email: '',
        name: '',
        role: 'admin',
        createdAt: DateTime.now(),
        isActive: false,
      );

  /// Convert model to json structure for storing data in firebase
  Map<String, dynamic> toJson() {
    return {
      'Email': email,
      'Name': name,
      'Role': role,
      'CreatedAt': createdAt.toIso8601String(),
      'LastLoginAt': lastLoginAt?.toIso8601String(),
      'IsActive': isActive,
    };
  }

  /// Factory method to create an admin model from a firebase document snapshot.
  factory AdminModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return AdminModel(
        id: document.id,
        email: data['Email'] ?? '',
        name: data['Name'] ?? '',
        role: data['Role'] ?? 'admin',
        createdAt: data['CreatedAt'] != null
            ? DateTime.parse(data['CreatedAt'])
            : DateTime.now(),
        lastLoginAt: data['LastLoginAt'] != null
            ? DateTime.parse(data['LastLoginAt'])
            : null,
        isActive: data['IsActive'] ?? true,
      );
    } else {
      return AdminModel.empty();
    }
  }

  /// Copy with method for updating fields
  AdminModel copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isActive,
  }) {
    return AdminModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

