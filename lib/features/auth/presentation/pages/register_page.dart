import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auto_guessr_mobile/core/theme/app_colors.dart';
import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';
import 'package:auto_guessr_mobile/core/utils/validators.dart';
import 'package:auto_guessr_mobile/core/widgets/widgets.dart';
import 'package:auto_guessr_mobile/features/auth/domain/auth_repository.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_form_state.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/register_cubit.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/widgets/auth_scaffold.dart';

/// "Enum amélioré" : chaque valeur porte son libellé.
// TODO(toi) : l'envoyer au backend quand il gérera ce champ.
enum _DriverLevel {
  beginner('Débutant'),
  enthusiast('Passionné'),
  expert('Expert'),
  driver('Pilote');

  const _DriverLevel(this.label);

  final String label;
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(context.read<AuthRepository>()),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  _DriverLevel _level = _DriverLevel.enthusiast;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<RegisterCubit>().submit(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AuthScaffold(
      currentTab: AuthTab.register,
      child: BlocBuilder<RegisterCubit, AuthFormState>(
        builder: (context, state) => Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.lg,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xs,
                  children: [
                    Text('NOUVELLE PARTIE', style: textTheme.headlineMedium),
                    Text(
                      'Ta Carte Pilote est prête en 30 secondes.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                CardexTextField(
                  label: 'Nom de pilote',
                  hint: 'ex. R34Hunter',
                  controller: _usernameController,
                  autofillHints: const [AutofillHints.newUsername],
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      Validators.required(value, field: 'Le nom de pilote'),
                ),
                CardexTextField(
                  label: 'Email',
                  hint: 'pilote@exemple.fr',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                ),
                CardexTextField(
                  label: 'Mot de passe',
                  hint: '8 caractères minimum',
                  controller: _passwordController,
                  isPassword: true,
                  autofillHints: const [AutofillHints.newPassword],
                  textInputAction: TextInputAction.done,
                  validator: Validators.newPassword,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.sm,
                  children: [
                    const PixelLabel('Ton niveau auto'),
                    CardexChoicePills<_DriverLevel>(
                      options: _DriverLevel.values,
                      selected: _level,
                      labelOf: (level) => level.label,
                      onSelected: (level) => setState(() => _level = level),
                    ),
                  ],
                ),
                const CardexNotice(
                  message:
                      'On collectionne des modèles, pas des personnes : '
                      'plaques et visages sont floutés automatiquement.',
                ),
                CardexCheckboxField(
                  label: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text("J'accepte les "),
                      CardexLink(
                        label: "conditions d'utilisation",
                        onTap: () => showComingSoon(context),
                      ),
                    ],
                  ),
                  validator: (accepted) => accepted == true
                      ? null
                      : 'Accepte les conditions pour commencer ta partie.',
                ),
                if (state case AuthFormFailure(:final message))
                  CardexNotice.error(message: message),
                CardexButton(
                  label: 'Créer mon CarDex',
                  showPlayIcon: true,
                  isLoading: state is AuthFormSubmitting,
                  onPressed: _submit,
                ),
                CardexInlineLink(
                  text: 'Déjà pilote ?',
                  linkLabel: 'Se connecter',
                  onTap: () => AuthScaffold.switchTo(context, AuthTab.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
