import 'package:flutter/material.dart';

class TagColors {
  // Define colorful tag colors like in home screen
  static final List<List<Color>> tagColors = [
    [Colors.pink[50]!, Colors.pink[100]!, Colors.pink[700]!],
    [Colors.indigo[50]!, Colors.indigo[100]!, Colors.indigo[700]!],
    [Colors.amber[50]!, Colors.amber[100]!, Colors.amber[700]!],
    [Colors.red[50]!, Colors.red[100]!, Colors.red[700]!],
    [Colors.cyan[50]!, Colors.cyan[100]!, Colors.cyan[700]!],
    [Colors.green[50]!, Colors.green[100]!, Colors.green[700]!],
    [Colors.orange[50]!, Colors.orange[100]!, Colors.orange[700]!],
    [Colors.purple[50]!, Colors.purple[100]!, Colors.purple[700]!],
    [Colors.teal[50]!, Colors.teal[100]!, Colors.teal[700]!],
    [Colors.blue[50]!, Colors.blue[100]!, Colors.blue[700]!],
  ];

  // Get colors for a specific tag index
  static List<Color> getColorsForIndex(int index) {
    return tagColors[index % tagColors.length];
  }

  // Get background color for a specific tag index
  static Color getBackgroundColor(int index) {
    return getColorsForIndex(index)[0];
  }

  // Get border color for a specific tag index
  static Color getBorderColor(int index) {
    return getColorsForIndex(index)[1];
  }

  // Get text color for a specific tag index
  static Color getTextColor(int index) {
    return getColorsForIndex(index)[2];
  }
}
