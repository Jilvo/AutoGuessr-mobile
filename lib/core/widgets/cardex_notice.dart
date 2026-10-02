import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_colors.dart';
import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';

/// Encadré d'information avec une icône ("plaques et visages floutés...").
/// La variante [CardexNotice.error] sert aux messages d'erreur.
class CardexNotice extends StatelessWidget {
  const CardexNotice({
    super.key,
    required this.message,
    this.icon = Icons.gpp_good_outlined,
    this.accentColor = AppColors.yellow,
  });

  const CardexNotice.error({super.key, required this.message})
    : icon = Icons.error_outline,
      accentColor = AppColors.error;

  final String message;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
