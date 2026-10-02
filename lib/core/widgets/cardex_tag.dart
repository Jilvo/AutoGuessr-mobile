import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';

/// Étiquette de catégorie : JDM, SPORTIVE, CITADINE...
/// Les couleurs prévues sont dans `AppColors.tagXxx`.
class CardexTag extends StatelessWidget {
  const CardexTag({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.sm - 2),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: Colors.white, fontSize: 10),
      ),
    );
  }
}
