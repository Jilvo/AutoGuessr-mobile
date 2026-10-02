import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_colors.dart';
import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';

/// Sélecteur à onglets : "SE CONNECTER | CRÉER UN COMPTE",
/// "NATIONAL | FRANCE | JAPON"...
class CardexSegmentedTabs extends StatelessWidget {
  const CardexSegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          for (final (index, label) in labels.indexed)
            Expanded(
              child: _Tab(
                label: label,
                selected: index == selectedIndex,
                onTap: () => onChanged(index),
              ),
            ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // `Semantics` : annonce "onglet sélectionné" au lecteur d'écran, puisqu'un
    // GestureDetector seul n'a aucun sens pour lui.
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: selected ? AppColors.cream : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md - 2),
          ),
          alignment: Alignment.center,
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected ? AppColors.ink : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
