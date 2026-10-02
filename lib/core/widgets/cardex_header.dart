import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_guessr_mobile/core/theme/app_colors.dart';
import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';
import 'package:auto_guessr_mobile/core/widgets/cardex_logo.dart';
import 'package:auto_guessr_mobile/core/widgets/circle_icon_button.dart';

/// Bandeau rouge du haut d'écran : bouton retour optionnel, logo centré,
/// action optionnelle à droite, puis les bandes "racing".
class CardexHeader extends StatelessWidget {
  const CardexHeader({super.key, this.onBack, this.trailing});

  /// `null` = pas de bouton retour.
  final VoidCallback? onBack;

  /// Ex : bouton de recherche sur l'écran CarDex.
  final Widget? trailing;

  /// Largeur réservée de chaque côté pour que le logo reste centré, qu'il y
  /// ait un bouton à gauche, à droite, les deux ou aucun.
  static const _sideSlot = 56.0;

  @override
  Widget build(BuildContext context) {
    // Icônes de la barre de statut (heure, batterie) en blanc sur le rouge.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColoredBox(
            color: AppColors.red,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: _sideSlot,
                      child: onBack == null
                          ? null
                          : CircleIconButton(
                              icon: Icons.chevron_left,
                              tooltip: 'Retour',
                              onPressed: onBack,
                            ),
                    ),
                    const Expanded(child: Center(child: CardexLogo())),
                    SizedBox(width: _sideSlot, child: trailing),
                  ],
                ),
              ),
            ),
          ),
          const RacingStripes(),
        ],
      ),
    );
  }
}

/// Les bandes blanches et rouges sous le bandeau.
class RacingStripes extends StatelessWidget {
  const RacingStripes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 10,
          width: double.infinity,
          child: ColoredBox(color: AppColors.cream),
        ),
        SizedBox(
          height: 6,
          width: double.infinity,
          child: ColoredBox(color: AppColors.red),
        ),
        SizedBox(
          height: 6,
          width: double.infinity,
          child: ColoredBox(color: AppColors.cream),
        ),
      ],
    );
  }
}
