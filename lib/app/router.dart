import 'package:go_router/go_router.dart';

import 'package:auto_guessr_mobile/app/routes.dart';
import 'package:auto_guessr_mobile/core/utils/stream_listenable.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_state.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/pages/splash_page.dart';
import 'package:auto_guessr_mobile/features/home/presentation/pages/home_page.dart';

GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: Routes.splash,
    // À chaque changement d'AuthState, GoRouter réévalue `redirect`.
    refreshListenable: StreamListenable(authCubit.stream),
    // Garde de navigation centralisée : aucun écran n'a à vérifier lui-même si
    // l'utilisateur est connecté. Renvoyer `null` = "pas de redirection".
    redirect: (context, state) {
      final location = state.matchedLocation;
      final onAuthPage =
          location == Routes.login || location == Routes.register;

      return switch (authCubit.state) {
        AuthUnknown() => location == Routes.splash ? null : Routes.splash,
        AuthUnauthenticated() => onAuthPage ? null : Routes.login,
        AuthAuthenticated() =>
          onAuthPage || location == Routes.splash ? Routes.home : null,
      };
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),
      GoRoute(path: Routes.register, builder: (_, _) => const RegisterPage()),
      GoRoute(path: Routes.home, builder: (_, _) => const HomePage()),
    ],
  );
}
