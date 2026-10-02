import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_colors.dart';
import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';

/// Choix unique parmi des pastilles ("Débutant | Passionné | Expert"...).
///
/// Générique (`<T>`) : les options peuvent être des String, un enum, des
/// objets... [labelOf] dit comment afficher chacune.
class CardexChoicePills<T> extends StatelessWidget {
  const CardexChoicePills({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  final List<T> options;
  final T? selected;
  final String Function(T option) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    // `Wrap` passe à la ligne si les pastilles ne tiennent pas sur la largeur.
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final option in options)
          _Pill(
            label: labelOf(option),
            selected: option == selected,
            onTap: () => onSelected(option),
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + 6,
            vertical: AppSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.yellow : Colors.transparent,
            border: Border.all(
              color: selected ? AppColors.yellow : AppColors.border,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: selected ? AppColors.ink : AppColors.textPrimary,
              fontSize: 16,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
