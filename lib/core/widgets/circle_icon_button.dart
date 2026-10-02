import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_colors.dart';

/// Bouton rond sombre : retour, recherche, réglages, favori...
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.size = 56,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  /// Obligatoire : c'est ce que lit le lecteur d'écran (accessibilité), un
  /// bouton qui n'affiche qu'une icône n'a pas d'autre texte.
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: size * 0.5),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        fixedSize: Size.square(size),
      ),
    );
  }
}
