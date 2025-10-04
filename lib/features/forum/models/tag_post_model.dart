class TagPostModel {
  final String id;
  final String name;
  final int usageCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  TagPostModel({
    required this.id,
    required this.name,
    required this.usageCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TagPostModel.fromMap(Map<String, dynamic> map) {
    return TagPostModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      usageCount: map['usageCount'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'usageCount': usageCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  TagPostModel copyWith({
    String? id,
    String? name,
    int? usageCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TagPostModel(
      id: id ?? this.id,
      name: name ?? this.name,
      usageCount: usageCount ?? this.usageCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
