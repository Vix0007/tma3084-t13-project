import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Text styles from the VanQ Figma type scale (Inter).
class AppText {
  AppText._();

  static TextStyle _inter(double size, FontWeight weight, double lineHeight,
      Color color) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      height: lineHeight / size,
      color: color,
      letterSpacing: 0,
    );
  }

  /// Large Title – Bold 30 / 36
  static TextStyle largeTitle({Color color = AppColors.textPrimary}) =>
      _inter(30, FontWeight.w700, 36, color);

  /// Title – Semi Bold 22 / 28
  static TextStyle title({Color color = AppColors.textPrimary}) =>
      _inter(22, FontWeight.w600, 28, color);

  /// Headline – Semi Bold 17 / 24
  static TextStyle headline({Color color = AppColors.textPrimary}) =>
      _inter(17, FontWeight.w600, 24, color);

  /// Body – Regular 15 / 22
  static TextStyle body({Color color = AppColors.textPrimary}) =>
      _inter(15, FontWeight.w400, 22, color);

  /// Label – Medium 13 / 18
  static TextStyle label({Color color = AppColors.textSecondary}) =>
      _inter(13, FontWeight.w500, 18, color);

  /// Caption – Regular 12 / 16
  static TextStyle caption({Color color = AppColors.textSecondary}) =>
      _inter(12, FontWeight.w400, 16, color);
}
