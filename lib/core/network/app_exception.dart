import 'package:dio/dio.dart';

/// Erreurs exposées au reste de l'app.
///
/// Règle : rien au-dessus de la couche `data/` ne doit connaître Dio.
/// Les repositories traduisent les `DioException` en `AppException`, et les
/// Cubits n'ont qu'à afficher `message`.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Serveur injoignable : pas de réseau, timeout, mauvaise URL...
final class NetworkException extends AppException {
  const NetworkException()
    : super('Impossible de joindre le serveur. Vérifie ta connexion.');
}

/// 401 : mauvais identifiants, ou token expiré / invalide.
final class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Identifiants invalides ou session expirée.',
  ]);
}

/// Toute autre réponse d'erreur du serveur (400, 422, 500...).
final class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode});

  final int? statusCode;
}

/// Traduit une erreur Dio en [AppException].
AppException mapDioException(DioException error) {
  final response = error.response;
  // Pas de réponse = la requête n'a jamais abouti (réseau, timeout...).
  if (response == null) {
    return const NetworkException();
  }

  final detail = _extractDetail(response.data);
  return switch (response.statusCode) {
    401 when detail != null => UnauthorizedException(detail),
    401 => const UnauthorizedException(),
    final code => ServerException(
      detail ?? 'Erreur serveur ($code).',
      statusCode: code,
    ),
  };
}

/// FastAPI renvoie ses erreurs sous la forme `{"detail": "..."}`, ou
/// `{"detail": [{"msg": "...", ...}]}` pour les erreurs de validation (422).
String? _extractDetail(Object? data) {
  if (data case {'detail': final String detail}) {
    return detail;
  }
  if (data case {'detail': [{'msg': final String msg}, ...]}) {
    return msg;
  }
  return null;
}
