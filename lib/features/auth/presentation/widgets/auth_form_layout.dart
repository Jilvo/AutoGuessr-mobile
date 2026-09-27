import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_form_state.dart';

/// Mise en page commune aux écrans de login et d'inscription : champs,
/// message d'erreur, bouton principal avec loader, et lien secondaire.
class AuthFormLayout extends StatelessWidget {
  const AuthFormLayout({
    super.key,
    required this.title,
    required this.formKey,
    required this.state,
    required this.fields,
    required this.submitLabel,
    required this.onSubmit,
    required this.secondaryLabel,
    required this.onSecondary,
  });

  final String title;
  final GlobalKey<FormState> formKey;
  final AuthFormState state;
  final List<Widget> fields;
  final String submitLabel;
  final VoidCallback onSubmit;
  final String secondaryLabel;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    final isSubmitting = state is AuthFormSubmitting;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      ...fields,
                      if (state case AuthFormFailure(:final message))
                        Text(
                          message,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      FilledButton(
                        // `onPressed: null` désactive le bouton : pas de double envoi.
                        onPressed: isSubmitting ? null : onSubmit,
                        child:
                            isSubmitting
                                ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(submitLabel),
                      ),
                      TextButton(
                        onPressed: isSubmitting ? null : onSecondary,
                        child: Text(secondaryLabel),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
