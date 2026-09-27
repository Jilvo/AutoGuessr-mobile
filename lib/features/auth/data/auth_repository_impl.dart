import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:auto_guessr_mobile/core/network/app_exception.dart';
import 'package:auto_guessr_mobile/core/storage/token_storage.dart';
import 'package:auto_guessr_mobile/features/auth/data/auth_api.dart';
import 'package:auto_guessr_mobile/features/auth/domain/auth_repository.dart';
import 'package:auto_guessr_mobile/features/auth/domain/user.dart';

/// Implémentation HTTP de [AuthRepository].
///
/// Son rôle : orchestrer l'API et le stockage du token, convertir les DTO en
/// objets du domaine, et traduire les erreurs techniques en `AppException`.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthApi api, required TokenStorage tokenStorage})
    : _api = api,
      _tokenStorage = tokenStorage;

  final AuthApi _api;
  final TokenStorage _tokenStorage;

  /// `broadcast` : plusieurs abonnés possibles (AuthCubit, et d'autres plus tard).
  final _userController = StreamController<User?>.broadcast();

  @override
  Stream<User?> get userChanges => _userController.stream;

  @override
  Future<User?> restoreSession() async {
    final token = await _tokenStorage.readAccessToken();
    if (token == null) {
      return null;
    }
    try {
      final user = await _guard(_api.me);
      return user.toDomain();
    } on UnauthorizedException {
      // Token expiré ou révoqué : on repart de zéro.
      await _tokenStorage.clear();
      return null;
    }
    // Les autres erreurs (réseau...) remontent : le token est gardé, pour ne
    // pas déconnecter quelqu'un qui ouvre l'app sans réseau.
  }

  @override
  Future<User> login({required String email, required String password}) async {
    final response = await _guard(
      () => _api.login(email: email, password: password),
    );
    return _startSession(response.accessToken, response.user.toDomain());
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String username,
  }) async {
    final response = await _guard(
      () => _api.register(email: email, password: password, username: username),
    );
    return _startSession(response.accessToken, response.user.toDomain());
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clear();
    _userController.add(null);
  }

  /// Appelé par l'intercepteur HTTP quand le serveur rejette le token.
  Future<void> handleSessionExpired() => logout();

  Future<User> _startSession(String accessToken, User user) async {
    await _tokenStorage.saveAccessToken(accessToken);
    _userController.add(user);
    return user;
  }

  /// Exécute un appel API en traduisant ses erreurs en [AppException].
  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw mapDioException(e);
    } on FormatException catch (e) {
      // Le JSON ne correspond pas aux DTO : regarde la console pour le détail.
      debugPrint('Réponse API inattendue : ${e.message}');
      throw const ServerException('Réponse inattendue du serveur.');
    }
  }
}
