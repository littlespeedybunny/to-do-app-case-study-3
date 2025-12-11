import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

/// Utility class for category color management
/// Provides default colors for each task category
class CategoryColorHelper {
  /// Get default color for a category (as hex string for storage)
  /// These are fixed colors that work well in both light and dark themes
  static String getCategoryColorHex(TaskCategory category) {
    switch (category) {
      case TaskCategory.personal:
        return '#EC4899'; // Pink/Rose - "Tümü" mavi kalacak
      case TaskCategory.work:
        return '#F8B739'; // Orange/Yellow
      case TaskCategory.school:
        return '#8338EC'; // Purple
      case TaskCategory.other:
        return '#10B981'; // Green (farklı bir renk)
    }
  }

  /// Convert hex string to Color
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Convert Color to hex string
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}

