/// Échelle d'espacements : on ne pioche que dans ces valeurs, ce qui donne
/// un rythme visuel régulier (et évite les 13, 17, 22... au hasard).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Rayons d'arrondi.
abstract final class AppRadius {
  static const double sm = 6;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 999;
}
