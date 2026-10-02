import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/core/theme/app_colors.dart';
import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';

/// Case à cocher avec son label, intégrée au `Form`.
///
/// Elle hérite de `FormField<bool>` : comme un `TextFormField`, elle accepte
/// un [validator] et affiche son erreur quand on appelle
/// `formKey.currentState!.validate()`. Pratique pour "J'accepte les CGU".
class CardexCheckboxField extends FormField<bool> {
  CardexCheckboxField({
    super.key,
    required Widget label,
    bool initialValue = false,
    ValueChanged<bool>? onChanged,
    super.validator,
  }) : super(
         initialValue: initialValue,
         builder: (field) {
           final theme = Theme.of(field.context);

           void toggle() {
             final newValue = !(field.value ?? false);
             field.didChange(newValue);
             onChanged?.call(newValue);
           }

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               // Toute la ligne est cliquable, pas seulement la petite case.
               InkWell(
                 onTap: toggle,
                 borderRadius: BorderRadius.circular(AppRadius.sm),
                 child: Row(
                   children: [
                     Checkbox(
                       value: field.value ?? false,
                       onChanged: (_) => toggle(),
                     ),
                     const SizedBox(width: AppSpacing.xs),
                     Expanded(
                       child: DefaultTextStyle.merge(
                         style: theme.textTheme.bodyLarge?.copyWith(
                           color: AppColors.textMuted,
                         ),
                         child: label,
                       ),
                     ),
                   ],
                 ),
               ),
               if (field.errorText case final error?)
                 Padding(
                   padding: const EdgeInsets.only(left: AppSpacing.md),
                   child: Text(
                     error,
                     style: theme.inputDecorationTheme.errorStyle,
                   ),
                 ),
             ],
           );
         },
       );
}
