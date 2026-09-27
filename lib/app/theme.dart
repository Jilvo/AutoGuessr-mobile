import 'package:flutter/material.dart';

abstract final class AppTheme {
  /// Material 3 génère toute la palette (primaire, surfaces, erreurs...)
  /// à partir d'une seule couleur.
  static const _seedColor = Colors.indigo;

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
  );
}
