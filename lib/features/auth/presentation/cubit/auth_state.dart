import 'package:auto_guessr_mobile/features/auth/domain/user.dart';

/// État global de la session. `sealed` : le compilateur connaît la liste
/// exhaustive des sous-classes, et un `switch` qui en oublie une ne compile pas.
sealed class AuthState {
  const AuthState();
}

/// Au démarrage, avant d'avoir vérifié le token stocké.
final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final User user;
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
