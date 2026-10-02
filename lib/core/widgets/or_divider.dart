import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';
import 'package:auto_guessr_mobile/core/widgets/pixel_label.dart';

/// Séparateur "──── OU ────".
class OrDivider extends StatelessWidget {
  const OrDivider({super.key, this.label = 'ou'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: PixelLabel(label),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
