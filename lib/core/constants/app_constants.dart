import 'package:flutter/material.dart';

/// App-wide constants
class AppConstants {
  // Database
  static const String databaseName = 'todo_note.db';
  static const int databaseVersion = 3;

  // Table names
  static const String notesTable = 'notes';
  static const String tasksTable = 'tasks';

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 20.0;
  static const double glassBlur = 10.0;
  static const double glassOpacity = 0.1;

  // Responsive breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;

  // Responsive padding helpers
  static double getPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 12.0; // Küçük ekranlar
    } else if (width < tabletBreakpoint) {
      return 16.0; // Orta ekranlar
    } else {
      return 24.0; // Büyük ekranlar
    }
  }

  // Responsive font size helpers
  static double getTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 22.0;
    } else if (width < tabletBreakpoint) {
      return 28.0;
    } else {
      return 32.0;
    }
  }
}
