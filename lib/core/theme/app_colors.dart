import 'package:flutter/material.dart';

/// Piggy Bank's brand palette.
///
/// Pink is the mascot/brand color, mint represents growth & savings,
/// sunshine yellow represents coins & rewards, and violet is reserved for
/// the AI assistant so it always reads as a distinct "voice" in the UI.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFFFF6B9D);
  static const Color primaryDark = Color(0xFFE85589);
  static const Color primaryLight = Color(0xFFFFD1E3);
  static const Color primaryContainer = Color(0xFFFFE8F1);

  static const Color secondary = Color(0xFF2EC4B6);
  static const Color secondaryDark = Color(0xFF1A9E92);
  static const Color secondaryLight = Color(0xFFCFF5F1);

  static const Color accentYellow = Color(0xFFFFC845);
  static const Color accentYellowDark = Color(0xFFE8A800);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPurpleLight = Color(0xFFEDE4FF);
  static const Color accentBlue = Color(0xFF4EA8DE);

  // Semantic
  static const Color success = Color(0xFF3DDC84);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFFF5470);
  static const Color info = Color(0xFF4EA8DE);

  // Needs vs wants tagging
  static const Color needs = Color(0xFF2EC4B6);
  static const Color wants = Color(0xFFFF9F5A);

  // Light theme neutrals
  static const Color backgroundLight = Color(0xFFFFF9F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceLightAlt = Color(0xFFFFF3ED);
  static const Color textPrimaryLight = Color(0xFF2D2438);
  static const Color textSecondaryLight = Color(0xFF6B6178);
  static const Color borderLight = Color(0xFFF0E4EC);

  // Dark theme neutrals
  static const Color backgroundDark = Color(0xFF1A1625);
  static const Color surfaceDark = Color(0xFF251F35);
  static const Color surfaceDarkAlt = Color(0xFF2E2740);
  static const Color textPrimaryDark = Color(0xFFF5F0FF);
  static const Color textSecondaryDark = Color(0xFFB3A8C7);
  static const Color borderDark = Color(0xFF3A3250);

  // Category colors (spending breakdown charts)
  static const List<Color> categoryPalette = <Color>[
    Color(0xFFFF6B9D),
    Color(0xFF2EC4B6),
    Color(0xFFFFC845),
    Color(0xFF8B5CF6),
    Color(0xFF4EA8DE),
    Color(0xFFFF9F5A),
    Color(0xFF3DDC84),
    Color(0xFFE85589),
  ];

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient savingsGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coinGradient = LinearGradient(
    colors: [accentYellow, accentYellowDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiGradient = LinearGradient(
    colors: [accentPurple, Color(0xFF6D28D9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
