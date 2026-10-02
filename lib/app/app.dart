import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:auto_guessr_mobile/app/router.dart';
import 'package:auto_guessr_mobile/core/theme/app_theme.dart';
import 'package:auto_guessr_mobile/features/auth/domain/auth_repository.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_cubit.dart';

class App extends StatefulWidget {
  const App({super.key, required this.authRepository, required this.authCubit});

  final AuthRepository authRepository;
  final AuthCubit authCubit;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// Créé une seule fois : s'il était créé dans `build`, chaque rebuild
  /// recréerait le routeur et ramènerait l'utilisateur à l'écran initial.
  late final GoRouter _router = createRouter(widget.authCubit);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Injection de dépendances : tout widget en dessous peut faire
    // `context.read<AuthRepository>()` ou `context.read<AuthCubit>()`.
    return RepositoryProvider<AuthRepository>.value(
      value: widget.authRepository,
      child: BlocProvider.value(
        value: widget.authCubit,
        child: MaterialApp.router(
          title: 'Auto Guessr',
          theme: AppTheme.dark,
          routerConfig: _router,
        ),
      ),
    );
  }
}
