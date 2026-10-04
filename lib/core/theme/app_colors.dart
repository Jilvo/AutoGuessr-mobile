import 'package:flutter/painting.dart';

/// Palette CarDex, relevée sur les wireframes.
///
/// Règle : aucun widget ne doit écrire `Color(0xFF...)` lui-même. Tout passe
/// par ici, pour pouvoir changer une teinte dans toute l'app en une ligne.
abstract final class AppColors {
  // Couleurs de marque
  static const red = Color(0xFFC8102E);
  static const green = Color(0xFF2E7D3E);
  static const blue = Color(0xFF2F5FA8);
  static const yellow = Color(0xFFF2B233);

  // Fonds
  static const background = Color(0xFF111214);
  static const surface = Color(0xFF1C1D21);
  static const border = Color(0xFF2E2F35);

  // Le "papier" des boîtes de dialogue et l'encre qui écrit dessus
  static const cream = Color(0xFFF1EFE9);
  static const ink = Color(0xFF111111);
  static const inkMuted = Color(0xFF55565B);

  // Palette "écran LCD" façon Game Boy : liste CarDex, dernière capture...
  static const lcd = Color(0xFFE3EBD2);
  static const lcdInk = Color(0xFF1E2416);
  static const lcdInkMuted = Color(0xFF5C6650);

  // Textes sur fond sombre
  static const textPrimary = Color(0xFFF1EFE9);
  static const textMuted = Color(0xFF9A9BA0);

  /// Plus clair que [red] : un message d'erreur doit rester lisible sur fond
  /// sombre et ne pas se confondre avec les boutons.
  static const error = Color(0xFFFF5A5F);

  // Catégories de voitures (tags)
  static const tagCitadine = Color(0xFF2E7D3E);
  static const tagJdm = Color(0xFFC0392B);
  static const tagSportive = Color(0xFFC2551A);
  static const tagYoungtimer = Color(0xFF2F5FA8);
  static const tagRallye = Color(0xFF7A5A35);
  static const tagElectrique = Color(0xFF2E7D3E);
  static const tagHybride = Color(0xFF2E7D3E);
}
