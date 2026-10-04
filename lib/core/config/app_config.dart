/// Configuration de l'app.
abstract final class AppConfig {
  /// URL de l'API.
  ///
  /// En développement : `127.0.0.1:8000` + `adb reverse tcp:8000 tcp:8000`.
  /// Le tunnel ADB redirige le `localhost` du téléphone (ou de l'émulateur)
  /// vers le `localhost` du PC, via USB. À relancer à chaque rebranchement.
  ///
  /// 👉 À remplacer par l'URL du backend déployé (en HTTPS).
  static const apiBaseUrl = 'http://127.0.0.1:8000';
}
