import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_colors.dart';
import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';
import 'package:auto_guessr_mobile/core/widgets/pixel_label.dart';

/// Boîte de dialogue façon jeu rétro (le "Chef d'atelier") : fond crème,
/// bordure noire épaisse, liseré clair à l'extérieur.
///
/// Sert aussi de conteneur pour le menu d'accueil ou les confirmations
/// (OUI / NON) : [child] peut être n'importe quel widget.
class RetroDialogBox extends StatelessWidget {
  const RetroDialogBox({super.key, this.speaker, required this.child});

  /// Qui parle, ex : "Chef d'atelier". Affiché en petit au-dessus.
  final String? speaker;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      // Liseré clair extérieur
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.cream,
            border: Border.all(color: AppColors.ink, width: 4),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md + 4,
            ),
            // Thème local : à l'intérieur de la boîte, les textes du thème
            // passent en encre noire (le thème global les met en clair).
            child: Theme(
              data: theme.copyWith(
                textTheme: theme.textTheme.apply(
                  bodyColor: AppColors.ink,
                  displayColor: AppColors.ink,
                ),
              ),
              child: DefaultTextStyle.merge(
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.ink,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (speaker case final speaker?) ...[
                      PixelLabel(speaker, color: AppColors.inkMuted),
                      const SizedBox(height: AppSpacing.sm - 2),
                    ],
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
