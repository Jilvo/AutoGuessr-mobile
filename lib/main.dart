import 'package:flutter/material.dart';

import 'package:auto_guessr_mobile/app/app.dart';
import 'package:auto_guessr_mobile/core/network/dio_factory.dart';
import 'package:auto_guessr_mobile/core/storage/token_storage.dart';
import 'package:auto_guessr_mobile/features/auth/data/auth_api.dart';
import 'package:auto_guessr_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_cubit.dart';

/// Point d'assemblage ("composition root") : le seul endroit qui connaît les
/// implémentations concrètes et les branche entre elles.
void main() {
  // Nécessaire pour utiliser des plugins natifs (secure storage) avant runApp.
  WidgetsFlutterBinding.ensureInitialized();

  final tokenStorage = TokenStorage();

  // Dépendance circulaire : le repository a besoin de Dio, et Dio doit pouvoir
  // prévenir le repository en cas de 401. On casse le cycle avec `late` + une
  // closure : la closure n'est exécutée qu'au premier 401, bien après
  // l'initialisation de `authRepository`.
  late final AuthRepositoryImpl authRepository;
  final dio = createDio(
    tokenStorage: tokenStorage,
    onUnauthorized: () => authRepository.handleSessionExpired(),
  );
  authRepository = AuthRepositoryImpl(
    api: AuthApi(dio),
    tokenStorage: tokenStorage,
  );

  final authCubit = AuthCubit(authRepository)..checkSession();

  runApp(App(authRepository: authRepository, authCubit: authCubit));
}
