import 'package:flutter/material.dart';

class IconHelper {
  /// Convert icon name string to IconData
  static IconData? getIconFromName(String iconName) {
    // Map icon names to Material Icons
    final iconMap = <String, IconData>{
      'info_outline': Icons.info_outline,
      'school_outlined': Icons.school_outlined,
      'health_and_safety_outlined': Icons.health_and_safety_outlined,
      'store_outlined': Icons.store_outlined,
      'calendar_today_outlined': Icons.calendar_today_outlined,
      'agriculture_outlined': Icons.agriculture_outlined,
      'home': Icons.home,
      'settings': Icons.settings,
      'person': Icons.person,
      'notifications': Icons.notifications,
      'search': Icons.search,
      'add': Icons.add,
      'edit': Icons.edit,
      'delete': Icons.delete,
      'camera': Icons.camera_alt,
      'image': Icons.image,
      'video': Icons.video_library,
      'article': Icons.article,
      'forum': Icons.forum,
      'calculator': Icons.calculate,
      'chart': Icons.bar_chart,
      'map': Icons.map,
      'location': Icons.location_on,
      'weather': Icons.wb_sunny,
      'farm': Icons.agriculture,
      'plant': Icons.local_florist,
      'leaf': Icons.eco,
      'water': Icons.water_drop,
      'fertilizer': Icons.science,
      'shopping': Icons.shopping_cart,
      'education': Icons.school,
      'care': Icons.medical_services,
      'info': Icons.info,
      'market': Icons.store,
      'calendar': Icons.calendar_month,
      'management': Icons.manage_accounts,
    };

    return iconMap[iconName] ?? Icons.help_outline;
  }

  /// Convert color int to Color
  static Color intToColor(int colorValue) {
    return Color(colorValue);
  }

  /// Convert Color to int
  static int colorToInt(Color color) {
    return color.value;
  }
}

