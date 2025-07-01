import 'package:flutter/material.dart';

class ColorPickerData {
  static const List<Map<String, dynamic>> colors = [
    {'color': '#FFFFFF', 'name': 'White', 'icon': Icons.brightness_7},
    {'color': '#FEF3C7', 'name': 'Yellow', 'icon': Icons.wb_sunny},
    {'color': '#DBEAFE', 'name': 'Blue', 'icon': Icons.water_drop},
    {'color': '#D1FAE5', 'name': 'Green', 'icon': Icons.eco},
    {'color': '#FCE7F3', 'name': 'Pink', 'icon': Icons.favorite},
    {'color': '#E0E7FF', 'name': 'Lavender', 'icon': Icons.local_florist},
    {'color': '#FED7D7', 'name': 'Coral', 'icon': Icons.waves},
    {'color': '#F3E8FF', 'name': 'Purple', 'icon': Icons.auto_awesome},
  ];

  static Color getColorFromHex(String hexColor) {
    return Color(int.parse(hexColor.substring(1), radix: 16) + 0xFF000000);
  }

  static IconData getSelectedColorIcon(String selectedColor) {
    final selectedColorData = colors.firstWhere(
      (color) => color['color'] == selectedColor,
      orElse: () => colors[0],
    );
    return selectedColorData['icon'];
  }

  static Map<String, dynamic> getColorData(String colorHex) {
    return colors.firstWhere(
      (color) => color['color'] == colorHex,
      orElse: () => colors[0],
    );
  }
}