import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_colors.dart';

/// Les trois polices des wireframes, rangées dans les "rôles" du `TextTheme`
/// de Material. Les widgets utilisent ensuite `Theme.of(context).textTheme.xxx`
/// au lieu de redéfinir leurs polices.
///
/// Les fichiers sont embarqués dans `assets/fonts/` et déclarés dans
/// pubspec.yaml. 👉 Pour changer une police : les deux endroits.
abstract final class AppTypography {
  /// Titres massifs : CARDEX, NOUVELLE PARTIE, CAPTURÉE !...
  static const _display = TextStyle(
    fontFamily: 'ArchivoBlack',
    color: AppColors.textPrimary,
    height: 1.1,
  );

  /// Police pixel "jeu vidéo" : labels, onglets, boutons.
  static const _pixel = TextStyle(
    fontFamily: 'Silkscreen',
    color: AppColors.textPrimary,
    letterSpacing: 1.5,
  );

  /// Texte courant.
  static const _body = TextStyle(
    fontFamily: 'Barlow',
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: _display.copyWith(fontSize: 44),
    displayMedium: _display.copyWith(fontSize: 32),
    headlineMedium: _display.copyWith(fontSize: 28),
    headlineSmall: _display.copyWith(fontSize: 22),
    titleMedium: _body.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
    bodyLarge: _body.copyWith(fontSize: 17),
    bodyMedium: _body.copyWith(fontSize: 15, color: AppColors.textMuted),
    // Boutons
    labelLarge: _pixel.copyWith(fontSize: 15, letterSpacing: 2),
    // Onglets
    labelMedium: _pixel.copyWith(fontSize: 12, letterSpacing: 1.5),
    // Labels de champs, petites mentions
    labelSmall: _pixel.copyWith(
      fontSize: 11,
      letterSpacing: 1.5,
      color: AppColors.textMuted,
    ),
  );
}
