import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brandPrimary,
        primary: AppColors.brandPrimary,
        secondary: AppColors.brandAccent,
        surface: AppColors.bgSurface,
      ),
      scaffoldBackgroundColor: AppColors.bgScreen,
      splashFactory: InkRipple.splashFactory,
    );
    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
    );
  }
}
