import 'package:flutter/material.dart';

abstract final class PoodleTheme {
  static const terracotta = Color(0xFFC9674A);
  static const spacing = 24.0;
  static const formWidth = 440.0;

  static ThemeData build() {
    final colors = ColorScheme.fromSeed(
      seedColor: terracotta,
      brightness: Brightness.light,
    ).copyWith(secondary: const Color(0xFF5E2F12));
    final base = ThemeData(useMaterial3: true, colorScheme: colors);
    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFFCFAF8),
      textTheme: base.textTheme.copyWith(
        headlineLarge: base.textTheme.headlineLarge?.copyWith(
          fontFamily: 'MontserratAlternates',
          fontWeight: FontWeight.w600,
          letterSpacing: -1,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorMaxLines: 3,
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: rounded,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          textStyle: base.textTheme.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: rounded,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          foregroundColor: colors.onSurface,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
        ),
      ),
    );
  }
}
