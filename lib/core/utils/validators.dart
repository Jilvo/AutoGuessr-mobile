/// Validateurs réutilisables pour les `TextFormField`.
///
/// Convention Flutter : un validateur renvoie `null` si la valeur est valide,
/// sinon le message d'erreur à afficher sous le champ.
abstract final class Validators {
  static String? required(String? value, {String field = 'Ce champ'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field est requis.';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "L'email est requis.";
    }
    // Volontairement simple : la vraie validation, c'est le serveur (et
    // l'email de confirmation). Ici on attrape juste les fautes de frappe.
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
      return 'Email invalide.';
    }
    return null;
  }

  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis.';
    }
    if (value.length < 8) {
      return 'Au moins 8 caractères.';
    }
    return null;
  }
}
