import 'package:dio/dio.dart';

import 'package:auto_guessr_mobile/features/auth/data/auth_response_dto.dart';
import 'package:auto_guessr_mobile/features/auth/data/user_dto.dart';

/// Appels HTTP bruts vers les endpoints d'authentification.
///
/// 👉 C'est LE fichier à adapter à ton backend : chemins, corps des requêtes.
/// Cette classe ne fait que du transport : pas de stockage, pas de gestion
/// d'erreur (c'est le rôle du repository).
class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  static const _loginPath = '/users/login';
  static const _registerPath = '/users/register';
  static const _mePath = '/users/me';

  Future<AuthResponseDto> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _loginPath,
      data: {'identifier': email, 'password': password},
      // Si ton backend utilise `OAuth2PasswordRequestForm` (FastAPI), il attend
      // un formulaire avec un champ `username` à la place du JSON :
      //   data: {'username': email, 'password': password},
      //   options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return AuthResponseDto.fromJson(response.data!);
  }

  /// Hypothèse : l'inscription renvoie la même chose que le login (token +
  /// user), ce qui connecte directement l'utilisateur.
  Future<AuthResponseDto> register({
    required String email,
    required String password,
    required String username,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _registerPath,
      data: {'email': email, 'password': password, 'username': username},
    );
    return AuthResponseDto.fromJson(response.data!);
  }

  /// Utilisateur associé au token courant (envoyé par l'intercepteur).
  Future<UserDto> me() async {
    final response = await _dio.get<Map<String, dynamic>>(_mePath);
    return UserDto.fromJson(response.data!);
  }
}
