import 'package:flutter/material.dart';

/// Petit texte en police pixel majuscule : "EMAIL", "TON NIVEAU AUTO"...
class PixelLabel extends StatelessWidget {
  const PixelLabel(this.text, {super.key, this.color, this.size});

  final String text;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall
          ?.copyWith(color: color, fontSize: size),
    );
  }
}
