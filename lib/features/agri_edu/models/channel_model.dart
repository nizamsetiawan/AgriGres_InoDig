class ChannelModel {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String subscriberCount;
  final String videoCount;
  final String category;
  final String color;
  final bool isVerified;

  ChannelModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.subscriberCount,
    required this.videoCount,
    required this.category,
    required this.color,
    this.isVerified = false,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      subscriberCount: json['subscriberCount'] ?? '0',
      videoCount: json['videoCount'] ?? '0',
      category: json['category'] ?? '',
      color: json['color'] ?? '#4CAF50',
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'subscriberCount': subscriberCount,
      'videoCount': videoCount,
      'category': category,
      'color': color,
      'isVerified': isVerified,
    };
  }
}
