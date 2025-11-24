import 'package:cloud_firestore/cloud_firestore.dart';

class HomeMenuModel {
  final String id;
  final String title;
  final String subtitle;
  final String route;
  final String iconName; // Icon identifier (e.g., 'info_outline', 'school_outlined')
  final int backgroundColor; // Color value as int
  final int iconColor; // Color value as int
  final int order; // Order for sorting
  final bool isActive; // Whether menu is active/visible

  HomeMenuModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.iconName,
    required this.backgroundColor,
    required this.iconColor,
    required this.order,
    this.isActive = true,
  });

  static HomeMenuModel empty() => HomeMenuModel(
    id: '',
    title: '',
    subtitle: '',
    route: '',
    iconName: '',
    backgroundColor: 0,
    iconColor: 0,
    order: 0,
    isActive: false,
  );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'route': route,
      'icon_name': iconName,
      'background_color': backgroundColor,
      'icon_color': iconColor,
      'order': order,
      'is_active': isActive,
    };
  }

  factory HomeMenuModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() == null) return HomeMenuModel.empty();
    
    final data = snapshot.data()!;
    return HomeMenuModel(
      id: snapshot.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      route: data['route'] ?? '',
      iconName: data['icon_name'] ?? '',
      backgroundColor: data['background_color'] ?? 0,
      iconColor: data['icon_color'] ?? 0,
      order: data['order'] ?? 0,
      isActive: data['is_active'] ?? true,
    );
  }

  factory HomeMenuModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return HomeMenuModel(
      id: id ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      route: json['route'] ?? '',
      iconName: json['icon_name'] ?? '',
      backgroundColor: json['background_color'] ?? 0,
      iconColor: json['icon_color'] ?? 0,
      order: json['order'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}

