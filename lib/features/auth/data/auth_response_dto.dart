import 'package:auto_guessr_mobile/features/auth/data/user_dto.dart';

/// Réponse du login / de l'inscription : `{access_token, token_type, user}`.
class AuthResponseDto {
  const AuthResponseDto({required this.accessToken, required this.user});

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'access_token': final String accessToken,
        'user': final Map<String, dynamic> user,
      } =>
        AuthResponseDto(accessToken: accessToken, user: UserDto.fromJson(user)),
      _ => throw FormatException(
        'Réponse d\'authentification inattendue : $json',
      ),
    };
  }

  final String accessToken;
  final UserDto user;
}
