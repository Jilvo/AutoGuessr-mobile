import 'package:auto_guessr_mobile/features/auth/domain/user.dart';

/// Représentation JSON d'un utilisateur, calquée sur la réponse de l'API.
class UserDto {
  const UserDto({
    required this.id,
    required this.email,
    required this.username,
    required this.pseudo,
    required this.isActive,
    required this.isAdmin,
    required this.createdAt,
  });

  /// Le pattern matching vérifie à la fois la présence ET le type de chaque
  /// champ. Si l'API change, on obtient une erreur claire qui montre le JSON
  /// reçu, plutôt qu'un obscur "Null is not a subtype of String".
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': final int id,
        'email': final String email,
        'username': final String username,
        'pseudo': final String pseudo,
        'is_active': final bool isActive,
        'is_admin': final bool isAdmin,
        'created_at': final String createdAt,
      } =>
        UserDto(
          id: id,
          email: email,
          username: username,
          pseudo: pseudo,
          isActive: isActive,
          isAdmin: isAdmin,
          createdAt: DateTime.parse(createdAt),
        ),
      _ => throw FormatException('JSON utilisateur inattendu : $json'),
    };
  }

  final int id;
  final String email;
  final String username;
  final String pseudo;
  final bool isActive;
  final bool isAdmin;
  final DateTime createdAt;

  User toDomain() => User(
    id: id,
    email: email,
    username: username,
    pseudo: pseudo,
    isAdmin: isAdmin,
  );
}
