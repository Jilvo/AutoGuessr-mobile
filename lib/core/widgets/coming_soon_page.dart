import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';
import 'package:auto_guessr_mobile/core/widgets/cardex_header.dart';
import 'package:auto_guessr_mobile/core/widgets/retro_dialog_box.dart';

/// Écran provisoire pour une fonctionnalité pas encore développée.
/// Permet de brancher la navigation dès maintenant.
class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Flèche retour seulement s'il y a un écran où revenir.
          CardexHeader(onBack: context.canPop() ? context.pop : null),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: RetroDialogBox(
                  speaker: "Chef d'atelier",
                  child: Text('$title : cet écran est encore au garage. '
                      'Reviens bientôt !'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
