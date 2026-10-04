import 'package:go_router/go_router.dart';

import 'package:auto_guessr_mobile/app/routes.dart';
import 'package:auto_guessr_mobile/core/utils/stream_listenable.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_state.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/pages/splash_page.dart';
import 'package:auto_guessr_mobile/features/home/presentation/pages/home_page.dart';
import 'package:auto_guessr_mobile/features/options/presentation/pages/options_page.dart';
import 'package:auto_guessr_mobile/features/profil/presentation/profil_page.dart';
import 'package:auto_guessr_mobile/features/scanner/presentation/pages/scanner_page.dart';

/// Pages réservées aux utilisateurs connectés. Toutes les autres sont publiques.
/// 👉 Ajoute ici les futures pages privées (historique...).
const _protectedRoutes = <String>{Routes.profile};

GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: Routes.home,
    // À chaque changement d'AuthState, GoRouter réévalue `redirect`.
    refreshListenable: StreamListenable(authCubit.stream),
    // Garde de navigation centralisée : aucun écran n'a à vérifier lui-même si
    // l'utilisateur est connecté. Renvoyer `null` = "pas de redirection".
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isProtected = _protectedRoutes.contains(location);
      final onAuthPage =
          location == Routes.login || location == Routes.register;
      final onSplash = location == Routes.splash;

      return switch (authCubit.state) {
        // Session en cours de vérification : les pages publiques s'affichent
        // tout de suite, les pages protégées attendent sur le splash.
        AuthUnknown() => isProtected ? Routes.splash : null,
        // Pas connecté : on ne bloque que les pages protégées. Le splash est
        // aussi quitté ici, sinon on y resterait bloqué une fois la
        // vérification terminée.
        AuthUnauthenticated() => isProtected || onSplash ? Routes.login : null,
        // Connecté : login, register et splash n'ont plus de raison d'être.
        AuthAuthenticated() => onAuthPage || onSplash ? Routes.home : null,
      };
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),
      GoRoute(path: Routes.register, builder: (_, _) => const RegisterPage()),
      GoRoute(path: Routes.home, builder: (_, _) => const HomePage()),
      GoRoute(path: Routes.scanner, builder: (_, _) => const ScannerPage()),
      GoRoute(path: Routes.profile, builder: (_, _) => const ProfilPage()),
      GoRoute(path: Routes.options, builder: (_, _) => const OptionsPage()),
    ],
  );
}
