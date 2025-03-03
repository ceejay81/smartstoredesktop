import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primary = Color(0xFF1E88E5);
  static const Color secondary = Color(0xFF26A69A);
  
  // Background Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  
  // Status Colors
  static const Color success = Color(0xFF66BB6A);
  static const Color warning = Color(0xFFFFB74D);
  static const Color danger = Color(0xFFEF5350);
  
  // Additional Colors
  static const Color tertiary = Color(0xFF7C4DFF);
  static const Color accent = Color(0xFFFF4081);
  
  // Chart Colors
  static const List<Color> chartColors = [
    primary,
    secondary,
    tertiary,
    accent,
  ];
  
  // Card Shadow
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}