/// Configuration injectée au moment du build via `--dart-define`.
///
/// Exemple : `flutter run --dart-define=API_BASE_URL=https://api.mondomaine.com`
abstract final class AppConfig {
  /// `10.0.2.2` est l'adresse du `localhost` de ta machine vue depuis
  /// l'émulateur Android (le `localhost` de l'émulateur, c'est lui-même).
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );
}
