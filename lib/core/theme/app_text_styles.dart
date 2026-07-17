import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system.
///
/// Headlines use "Baloo 2" (a rounded, playful display face) to keep the
/// app feeling friendly for kids; body copy uses "Nunito" for readability
/// at small sizes so parents/guardians can comfortably read statements.
abstract final class AppTextStyles {
  static TextStyle _display(double size, FontWeight weight, Color color) =>
      GoogleFonts.baloo2(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.2,
      );

  static TextStyle _body(double size, FontWeight weight, Color color) =>
      GoogleFonts.nunito(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.4,
      );

  static TextStyle displayLarge(Color color) => _display(32, FontWeight.w800, color);
  static TextStyle displayMedium(Color color) => _display(28, FontWeight.w700, color);
  static TextStyle headlineLarge(Color color) => _display(24, FontWeight.w700, color);
  static TextStyle headlineMedium(Color color) => _display(20, FontWeight.w700, color);
  static TextStyle titleLarge(Color color) => _body(18, FontWeight.w700, color);
  static TextStyle titleMedium(Color color) => _body(16, FontWeight.w700, color);
  static TextStyle bodyLarge(Color color) => _body(16, FontWeight.w400, color);
  static TextStyle bodyMedium(Color color) => _body(14, FontWeight.w400, color);
  static TextStyle bodySmall(Color color) => _body(12, FontWeight.w400, color);
  static TextStyle labelLarge(Color color) => _body(14, FontWeight.w700, color);
  static TextStyle labelSmall(Color color) => _body(11, FontWeight.w600, color);

  /// Big animated balance figures on Home / Piggy Bank Balance.
  static TextStyle balanceDisplay(Color color) => _display(48, FontWeight.w800, color);

  static TextTheme textTheme(Color primaryText, Color secondaryText) => TextTheme(
        displayLarge: displayLarge(primaryText),
        displayMedium: displayMedium(primaryText),
        headlineLarge: headlineLarge(primaryText),
        headlineMedium: headlineMedium(primaryText),
        titleLarge: titleLarge(primaryText),
        titleMedium: titleMedium(primaryText),
        bodyLarge: bodyLarge(primaryText),
        bodyMedium: bodyMedium(secondaryText),
        bodySmall: bodySmall(secondaryText),
        labelLarge: labelLarge(primaryText),
        labelSmall: labelSmall(secondaryText),
      );
}
