import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';
import 'package:auto_guessr_mobile/core/widgets/pixel_label.dart';

/// Champ de formulaire CarDex : label pixel au-dessus, champ sombre en dessous.
///
/// Le style du champ lui-même vient de `inputDecorationTheme` (app_theme.dart) ;
/// ce widget ajoute le label, l'action optionnelle et l'œil des mots de passe.
class CardexTextField extends StatefulWidget {
  const CardexTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.labelAction,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.onFieldSubmitted,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;

  /// Widget aligné à droite du label, ex : le lien "Oublié ?".
  final Widget? labelAction;

  /// Masque la saisie et ajoute un bouton pour l'afficher.
  final bool isPassword;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<CardexTextField> createState() => _CardexTextFieldState();
}

class _CardexTextFieldState extends State<CardexTextField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: PixelLabel(widget.label)),
            if (widget.labelAction case final action?) action,
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          validator: widget.validator,
          onFieldSubmitted: widget.onFieldSubmitted,
          obscureText: widget.isPassword && _obscured,
          // Pas de correcteur ni de suggestions sur un mot de passe : le
          // clavier pourrait sinon mémoriser ce qui est tapé.
          autocorrect: !widget.isPassword,
          enableSuggestions: !widget.isPassword,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: widget.isPassword
                ? IconButton(
                    tooltip: _obscured
                        ? 'Afficher le mot de passe'
                        : 'Masquer le mot de passe',
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscured = !_obscured),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
