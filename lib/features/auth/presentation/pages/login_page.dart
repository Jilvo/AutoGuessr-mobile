import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:auto_guessr_mobile/app/routes.dart';
import 'package:auto_guessr_mobile/core/utils/validators.dart';
import 'package:auto_guessr_mobile/features/auth/domain/auth_repository.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_form_state.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/login_cubit.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/widgets/auth_form_layout.dart';

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
    return BlocBuilder<LoginCubit, AuthFormState>(
      builder:
          (context, state) => AuthFormLayout(
            title: 'Connexion',
            formKey: _formKey,
            state: state,
            submitLabel: 'Se connecter',
            onSubmit: _submit,
            secondaryLabel: "Pas encore de compte ? S'inscrire",
            onSecondary: () => context.push(Routes.register),
            fields: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                validator: Validators.email,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                // Au login, on vérifie juste que le champ est rempli : les règles de
                // complexité s'appliquent à la création, pas aux comptes existants.
                validator:
                    (value) =>
                        Validators.required(value, field: 'Le mot de passe'),
              ),
            ],
          ),
    );
  }
}
