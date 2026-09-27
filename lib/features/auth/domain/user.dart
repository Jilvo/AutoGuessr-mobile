/// L'utilisateur tel que l'app le manipule.
///
/// Volontairement indépendant du format JSON de l'API (voir `UserDto`) :
/// si le backend renomme un champ, seul le DTO change, pas l'UI.
class User {
  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.pseudo,
    required this.isAdmin,
  });

  final int id;
  final String email;
  final String username;
  final String pseudo;
  final bool isAdmin;
}
