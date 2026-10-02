import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';

enum CardexButtonVariant { primary, secondary }

/// Bouton pleine largeur CarDex.
///
/// - `primary` : rouge plein ("CONTINUER LA PARTIE").
/// - `secondary` : contour ("CONTINUER LA CHASSE", "Google").
///
/// Les couleurs et la forme viennent du thème (`filledButtonTheme` et
/// `outlinedButtonTheme`). Ce widget ajoute ce que le thème ne sait pas
/// faire : l'icône ▶, le loader et la mise en majuscules.
class CardexButton extends StatelessWidget {
  const CardexButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = CardexButtonVariant.primary,
    this.showPlayIcon = false,
    this.isLoading = false,
    this.pixelFont = true,
  });

  const CardexButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.showPlayIcon = false,
    this.isLoading = false,
    this.pixelFont = true,
  }) : variant = CardexButtonVariant.secondary;

  final String label;

  /// `null` désactive le bouton.
  final VoidCallback? onPressed;
  final CardexButtonVariant variant;

  /// Affiche le ▶ devant le texte, comme dans un menu de jeu.
  final bool showPlayIcon;

  /// Remplace le texte par un loader et désactive le bouton (pas de double envoi).
  final bool isLoading;

  /// `false` pour un texte normal, ex : les boutons "Google" / "Apple".
  final bool pixelFont;

  @override
  Widget build(BuildContext context) {
    final onPressed = isLoading ? null : this.onPressed;
    final textStyle = pixelFont
        ? null // garde le style du thème (police pixel)
        : Theme.of(context).textTheme.titleMedium;

    final Widget child = isLoading
        ? const SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showPlayIcon) ...[
                const Icon(Icons.play_arrow_rounded, size: 24),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(
                child: Text(
                  pixelFont ? label.toUpperCase() : label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    return switch (variant) {
      CardexButtonVariant.primary => FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(textStyle: textStyle),
        child: child,
      ),
      CardexButtonVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(textStyle: textStyle),
        child: child,
      ),
    };
  }
}
