import 'package:auto_guessr_mobile/features/auth/domain/user.dart';

/// Contrat de l'authentification : ce que l'app peut faire, pas comment.
///
/// La présentation (Cubits) ne dépend que de cette interface. L'implémentation
/// HTTP est dans `data/`, et les tests utilisent une fausse implémentation.
///
/// Toutes les méthodes peuvent lever une `AppException`.
abstract interface class AuthRepository {
  /// Émet l'utilisateur à chaque connexion, et `null` à chaque déconnexion
  /// (volontaire ou session expirée).
  Stream<User?> get userChanges;

  /// Au démarrage : restaure la session à partir du token stocké.
  /// Renvoie `null` s'il n'y a pas de session valide.
  Future<User?> restoreSession();

  Future<User> login({required String email, required String password});

  Future<User> register({
    required String email,
    required String password,
    required String username,
  });

  Future<void> logout();
}
