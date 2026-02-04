import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Vibrant Palette)
  static const Color royalIndigo = Color(
    0xFF303F9F,
  ); // Primary - Stability & Luxury
  static const Color sunsetOrange = Color(0xFFFF5722); // Accents & CTAs
  static const Color electricBlue = Color(0xFF2196F3); // Secondary highlights
  static const Color vividAmber = Color(0xFFFFC107); // Status highlights

  // Base Colors
  static const Color pureWhite = Color(0xFFFFFFFF); // Main background
  static const Color midnightBlack = Color(0xFF121212); // Bold headings

  // Legacy aliases for compatibility
  static const Color primary = royalIndigo;
  static const Color accent = sunsetOrange;
  static const Color background = pureWhite;
  static const Color surface = pureWhite;
  static const Color error = Color(0xFFD32F2F);
  static const Color textPrimary = midnightBlack;
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [royalIndigo, electricBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [sunsetOrange, vividAmber],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glassmorphism
  static const Color glassBackground = Color(0x40FFFFFF); // 25% opacity white
  static const Color glassBorder = Color(0x60FFFFFF); // 38% opacity white
}
