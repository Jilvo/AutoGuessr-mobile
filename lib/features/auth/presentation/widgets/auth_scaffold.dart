import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:auto_guessr_mobile/app/routes.dart';
import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';
import 'package:auto_guessr_mobile/core/widgets/widgets.dart';

enum AuthTab { login, register }

/// Squelette commun aux écrans de connexion et d'inscription :
/// en-tête rouge avec retour, onglets, puis le contenu propre à chaque page.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.currentTab,
    required this.child,
  });

  final AuthTab currentTab;
  final Widget child;

  /// Bascule vers l'autre onglet. `replace` remplace l'écran courant au lieu
  /// d'en empiler un nouveau : le bouton retour ramène à l'écran d'avant
  /// l'authentification, pas à l'autre onglet.
  static void switchTo(BuildContext context, AuthTab tab) {
    context.replace(switch (tab) {
      AuthTab.login => Routes.login,
      AuthTab.register => Routes.register,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CardexHeader(
            // Arrivé ici par `go` (pile vide), il n'y a rien à dépiler :
            // on retourne alors explicitement à l'accueil.
            onBack: () =>
                context.canPop() ? context.pop() : context.go(Routes.home),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: Center(
                // Sur tablette, le formulaire ne s'étire pas sur toute la largeur.
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CardexSegmentedTabs(
                        labels: const ['Se connecter', 'Créer un compte'],
                        selectedIndex: currentTab.index,
                        onChanged: (index) {
                          final tab = AuthTab.values[index];
                          if (tab != currentTab) switchTo(context, tab);
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fonctionnalités prévues sur les maquettes mais pas encore branchées.
void showComingSoon(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(const SnackBar(content: Text('Bientôt disponible 🚧')));
}
