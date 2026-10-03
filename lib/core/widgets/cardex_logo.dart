import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_colors.dart';
import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';

/// Logo : l'objectif photo jaune + le mot "CARDEX" avec son ombre portée.
class CardexLogo extends StatelessWidget {
  const CardexLogo({super.key, this.size = 32});

  /// Hauteur du texte ; l'objectif s'adapte proportionnellement.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Lens(size: size * 1.2),
        const SizedBox(width: AppSpacing.sm + 2),
      ],
    );
  }
}

class CardexLogoText extends StatelessWidget {
  const CardexLogoText({super.key, this.size = 32});

  /// Hauteur du texte ; l'objectif s'adapte proportionnellement.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'CARDEX',
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        fontSize: size,
        color: Colors.white,
        // L'ombre décalée, sans flou, donne l'effet "sticker" du wireframe.
        shadows: [Shadow(offset: Offset(size * 0.08, size * 0.08))],
      ),
    );
  }
}

class CardexLogoExtended extends StatelessWidget {
  const CardexLogoExtended({super.key, this.size = 32});

  /// Hauteur du texte ; l'objectif s'adapte proportionnellement.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CardexLogo(size: size),
        CardexLogoText(size: size),
      ],
    );
  }
}

class _Lens extends StatelessWidget {
  const _Lens({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.yellow,
        border: Border.all(color: AppColors.cream, width: size * 0.1),
      ),
      alignment: Alignment.center,
      child: Container(
        width: size * 0.5,
        height: size * 0.5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFB07A10), width: 2),
        ),
      ),
    );
  }
}
