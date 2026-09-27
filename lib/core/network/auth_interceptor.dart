import 'package:dio/dio.dart';

import 'package:auto_guessr_mobile/core/storage/token_storage.dart';

/// Ajoute le token à chaque requête et détecte les sessions expirées.
///
/// Un intercepteur est un "middleware" côté client : toutes les requêtes et
/// réponses passent par lui, donc cette logique n'est écrite qu'une seule fois.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required this.onUnauthorized,
  }) : _tokenStorage = tokenStorage;

  final TokenStorage _tokenStorage;

  /// Appelé quand le serveur rejette notre token.
  /// 👉 C'est ici que tu brancheras le refresh token plus tard : tenter un
  /// refresh, rejouer la requête, et ne déconnecter qu'en cas d'échec.
  final void Function() onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Un 401 sur une requête envoyée SANS token (ex : mauvais mot de passe au
    // login) n'est pas une session expirée : on ne déconnecte pas dans ce cas.
    final sentToken = err.requestOptions.headers.containsKey('Authorization');
    if (err.response?.statusCode == 401 && sentToken) {
      onUnauthorized();
    }
    handler.next(err);
  }
}
