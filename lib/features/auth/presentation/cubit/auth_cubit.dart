import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auto_guessr_mobile/core/network/app_exception.dart';
import 'package:auto_guessr_mobile/features/auth/domain/auth_repository.dart';
import 'package:auto_guessr_mobile/features/auth/domain/user.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_state.dart';

/// Cubit global : "qui est connecté ?". Le routeur l'écoute pour rediriger.
///
/// Il ne fait pas lui-même le login : il écoute `userChanges` du repository.
/// Ainsi, un login, une inscription ou une session expirée (401 détecté par
/// l'intercepteur) mettent tous à jour la session par le même chemin.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthUnknown()) {
    _userSubscription = _authRepository.userChanges.listen(_onUserChanged);
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _userSubscription;

  Future<void> checkSession() async {
    try {
      _onUserChanged(await _authRepository.restoreSession());
    } on AppException {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> logout() => _authRepository.logout();

  void _onUserChanged(User? user) {
    emit(user == null ? const AuthUnauthenticated() : AuthAuthenticated(user));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
