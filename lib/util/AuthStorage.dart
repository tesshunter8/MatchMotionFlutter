import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static final _storage = FlutterSecureStorage();
  static const _keyIdToken = 'idToken';
  static const _keyRefreshToken = 'refreshToken';

  // Save tokens
  static Future<void> saveTokens(String idToken, String refreshToken) async {
    await _storage.write(key: _keyIdToken, value: idToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  // Get ID token
  static Future<String?> getIdToken() async {
    return await _storage.read(key: _keyIdToken);
  }

  // Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  // Clear tokens
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}