import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stocke le token d'accès de façon chiffrée (Keychain sur iOS, Keystore sur
/// Android), contrairement à SharedPreferences qui écrit en clair sur le disque.
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';

  final FlutterSecureStorage _storage;

  /// Cache mémoire : le token est lu à chaque requête HTTP, et le stockage
  /// sécurisé est lent (appel natif + déchiffrement).
  String? _cachedToken;

  Future<String?> readAccessToken() async {
    return _cachedToken ??= await _storage.read(key: _accessTokenKey);
  }

  Future<void> saveAccessToken(String token) async {
    _cachedToken = token;
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<void> clear() async {
    _cachedToken = null;
    await _storage.delete(key: _accessTokenKey);
  }
}
