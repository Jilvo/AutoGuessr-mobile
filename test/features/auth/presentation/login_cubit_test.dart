import 'package:flutter_test/flutter_test.dart';

import 'package:auto_guessr_mobile/core/network/app_exception.dart';
import 'package:auto_guessr_mobile/features/auth/domain/auth_repository.dart';
import 'package:auto_guessr_mobile/features/auth/domain/user.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_form_state.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/login_cubit.dart';

/// Fausse implémentation écrite à la main : c'est possible (et simple) parce
/// que le Cubit dépend de l'interface `AuthRepository`, pas de Dio.
class FakeAuthRepository implements AuthRepository {
  AppException? errorToThrow;

  static const user = User(
    id: 1,
    email: 'demo@auto-guessr.local',
    username: 'player_one',
    pseudo: 'player_one',
    isAdmin: false,
  );

  @override
  Stream<User?> get userChanges => const Stream.empty();

  @override
  Future<User?> restoreSession() async => null;

  @override
  Future<User> login({required String email, required String password}) async {
    if (errorToThrow case final error?) throw error;
    return user;
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String username,
  }) async {
    if (errorToThrow case final error?) throw error;
    return user;
  }

  @override
  Future<void> logout() async {}
}

void main() {
  late FakeAuthRepository repository;
  late LoginCubit cubit;

  setUp(() {
    repository = FakeAuthRepository();
    cubit = LoginCubit(repository);
  });

  tearDown(() => cubit.close());

  test("l'état initial est Idle", () {
    expect(cubit.state, isA<AuthFormIdle>());
  });

  test('émet Submitting puis Success quand le login réussit', () async {
    // On s'abonne AVANT d'agir, pour ne rater aucun état émis.
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthFormSubmitting>(), isA<AuthFormSuccess>()]),
    );

    await cubit.submit(email: 'demo@auto-guessr.local', password: 'secret');

    await states;
  });

  test("émet Submitting puis Failure avec le message de l'erreur", () async {
    repository.errorToThrow = const UnauthorizedException(
      'Mauvais identifiants',
    );

    final states = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<AuthFormSubmitting>(),
        isA<AuthFormFailure>().having(
          (state) => state.message,
          'message',
          'Mauvais identifiants',
        ),
      ]),
    );

    await cubit.submit(email: 'demo@auto-guessr.local', password: 'faux');

    await states;
  });
}
