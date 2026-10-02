import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_colors.dart';
import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';
import 'package:auto_guessr_mobile/core/theme/app_typography.dart';

/// Thème global : il style les widgets Material "de base" (champs, boutons,
/// checkbox...). Un simple `FilledButton` ou `TextFormField` a donc déjà le
/// look CarDex, sans rien préciser.
abstract final class AppTheme {
  static ThemeData get dark {
    final textTheme = AppTypography.textTheme;

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.red,
        onPrimary: Colors.white,
        secondary: AppColors.yellow,
        onSecondary: AppColors.ink,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.ink,
      ),
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: textTheme.bodyLarge!.copyWith(color: AppColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg - 4,
          vertical: AppSpacing.md + 2,
        ),
        border: _outline(AppColors.border),
        enabledBorder: _outline(AppColors.border),
        focusedBorder: _outline(AppColors.yellow, width: 2),
        errorBorder: _outline(AppColors.error),
        focusedErrorBorder: _outline(AppColors.error, width: 2),
        errorStyle: textTheme.bodyMedium!.copyWith(
          color: AppColors.error,
          fontSize: 13,
        ),
        suffixIconColor: AppColors.textMuted,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.red.withValues(alpha: 0.5),
          disabledForegroundColor: Colors.white70,
          minimumSize: const Size.fromHeight(56),
          shape: _rounded(AppRadius.md),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          minimumSize: const Size.fromHeight(56),
          shape: _rounded(AppRadius.md),
          textStyle: textTheme.labelLarge,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        // `WidgetStateProperty` : la valeur dépend de l'état du widget
        // (coché, désactivé, survolé...).
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.yellow
              : AppColors.cream,
        ),
        checkColor: const WidgetStatePropertyAll(AppColors.ink),
        side: const BorderSide(color: AppColors.border),
        shape: _rounded(AppRadius.sm - 2),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: textTheme.bodyLarge,
        behavior: SnackBarBehavior.floating,
        shape: _rounded(AppRadius.md),
      ),
    );
  }

  static OutlineInputBorder _outline(Color color, {double width = 1.5}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static RoundedRectangleBorder _rounded(double radius) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
  }
}
