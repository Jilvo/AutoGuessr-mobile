import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_colors.dart';

/// Lien jaune souligné : "Oublié ?", "Créer un compte"...
class CardexLink extends StatelessWidget {
  const CardexLink({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.yellow,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.yellow,
          ),
        ),
      ),
    );
  }
}

/// Phrase centrée terminée par un lien :
/// "Pas encore de CarDex ? **Créer un compte**".
class CardexInlineLink extends StatelessWidget {
  const CardexInlineLink({
    super.key,
    required this.text,
    required this.linkLabel,
    required this.onTap,
  });

  final String text;
  final String linkLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '$text ',
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: AppColors.textMuted),
        ),
        CardexLink(label: linkLabel, onTap: onTap),
      ],
    );
  }
}
