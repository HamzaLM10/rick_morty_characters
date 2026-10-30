import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.slate,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.amber,
        onPrimary: AppColors.onAmber,
        surface: AppColors.slate,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.amber,
        foregroundColor: AppColors.onAmber,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        scrolledUnderElevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.onAmber,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}