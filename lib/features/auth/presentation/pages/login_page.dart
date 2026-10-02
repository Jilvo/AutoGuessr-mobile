import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';
import 'package:auto_guessr_mobile/core/utils/validators.dart';
import 'package:auto_guessr_mobile/core/widgets/widgets.dart';
import 'package:auto_guessr_mobile/features/auth/domain/auth_repository.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_form_state.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/login_cubit.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/widgets/auth_scaffold.dart';

/// Le `BlocProvider` crée le Cubit ET le ferme automatiquement quand la page
/// disparaît. Le Cubit vit donc exactement aussi longtemps que l'écran.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<AuthRepository>()),
      child: const _LoginView(),
    );
  }
}

/// `StatefulWidget` car les `TextEditingController` et la `GlobalKey` doivent
/// survivre aux rebuilds, et les controllers doivent être libérés (`dispose`).
class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<LoginCubit>().submit(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pas de navigation après un login réussi : l'AuthCubit change d'état et
    // c'est le routeur qui redirige (voir `redirect` dans router.dart).
    return AuthScaffold(
      currentTab: AuthTab.login,
      child: BlocBuilder<LoginCubit, AuthFormState>(
        builder: (context, state) => Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.lg,
              children: [
                const RetroDialogBox(
                  speaker: "Chef d'atelier",
                  child: Text("Bon retour au garage ! Ton CarDex t'attend."),
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
                  hint: '••••••••',
                  controller: _passwordController,
                  isPassword: true,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  labelAction: CardexLink(
                    label: 'Oublié ?',
                    onTap: () => showComingSoon(context),
                  ),
                  // Au login, on vérifie juste que le champ est rempli : les
                  // règles de complexité s'appliquent à la création de compte.
                  validator: (value) =>
                      Validators.required(value, field: 'Le mot de passe'),
                ),
                // TODO(toi) : brancher "Rester connecté". Piste : si décoché,
                // garder le token en mémoire seulement (voir TokenStorage).
                CardexCheckboxField(
                  label: const Text('Rester connecté'),
                  initialValue: true,
                ),
                if (state case AuthFormFailure(:final message))
                  CardexNotice.error(message: message),
                CardexButton(
                  label: 'Continuer la partie',
                  showPlayIcon: true,
                  isLoading: state is AuthFormSubmitting,
                  onPressed: _submit,
                ),
                const OrDivider(),
                Row(
                  spacing: AppSpacing.md,
                  children: [
                    Expanded(
                      child: CardexButton.secondary(
                        label: 'Google',
                        pixelFont: false,
                        onPressed: () => showComingSoon(context),
                      ),
                    ),
                    Expanded(
                      child: CardexButton.secondary(
                        label: 'Apple',
                        pixelFont: false,
                        onPressed: () => showComingSoon(context),
                      ),
                    ),
                  ],
                ),
                CardexInlineLink(
                  text: 'Pas encore de CarDex ?',
                  linkLabel: 'Créer un compte',
                  onTap: () => AuthScaffold.switchTo(context, AuthTab.register),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
