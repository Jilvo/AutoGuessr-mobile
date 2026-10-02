import 'package:auto_guessr_mobile/app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_state.dart';
import 'package:go_router/go_router.dart';

/// Écran d'accueil provisoire, pour vérifier que l'authentification fonctionne.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = switch (context.watch<AuthCubit>().state) {
      AuthAuthenticated(:final user) => user,
      _ => null,
    };

    bool isUserAuthenticated = user != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto Guessr'),
        actions: [
          IconButton(
            tooltip: isUserAuthenticated ? 'Se déconnecter' : 'Se connecter',
            icon: isUserAuthenticated
                ? const Icon(Icons.logout)
                : const Icon(Icons.login),
            // Pas de navigation ici non plus : le routeur redirige vers le login.
            onPressed: () => isUserAuthenticated
                ? context.read<AuthCubit>().logout()
                : context.go(Routes.login),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Bienvenue ${user?.pseudo ?? 'Inconnu'} !',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
