import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.surface,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurface,
    ),

    scaffoldBackgroundColor: AppColors.background,
    dividerColor: AppColors.divider,

    // Text theme
    textTheme: const TextTheme(
      displayLarge: AppTypography.h1,
      displayMedium: AppTypography.h2,
      titleLarge: AppTypography.h3,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.caption,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.h2,
      iconTheme: IconThemeData(color: AppColors.onBackground),
    ),

    // Card
    cardTheme: CardTheme(
      elevation: 0,
      color: AppColors.surface,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.onPrimary,
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error),
      ),
    ),

    // ListTile mặc định
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),

    // Icon
    iconTheme: const IconThemeData(size: 24, color: AppColors.onBackground),
  );

  /// Theme dark
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.secondary,
      primaryContainer: AppColors.primary,
      secondary: AppColors.primary,
      error: AppColors.error,
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),

    scaffoldBackgroundColor: const Color(0xFF121212),
    dividerColor: Colors.grey.shade800,

    textTheme: TextTheme(
      displayLarge: AppTypography.h1.copyWith(color: Colors.white),
      displayMedium: AppTypography.h2.copyWith(color: Colors.white),
      titleLarge: AppTypography.h3.copyWith(color: Colors.white),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: Colors.white),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: Colors.white70),
      bodySmall: AppTypography.caption.copyWith(color: Colors.grey.shade400),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.h2.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    cardTheme: CardTheme(
      elevation: 0,
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade800, width: 1),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.secondary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error),
      ),
    ),

    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),

    iconTheme: const IconThemeData(size: 24, color: Colors.white),
  );
}
