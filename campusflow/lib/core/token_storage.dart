import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Le jeton est rangé dans le stockage sécurisé (Keystore Android / Keychain iOS),
/// jamais en clair dans les préférences.
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _key = 'auth_token';

  Future<String?> read() => _storage.read(key: _key);
  Future<void> write(String token) => _storage.write(key: _key, value: token);
  Future<void> delete() => _storage.delete(key: _key);
}
