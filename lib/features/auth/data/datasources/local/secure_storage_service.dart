import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Secure storage service for sensitive data like tokens and user preferences
@lazySingleton
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Keys for stored data
  static const String _userTokenKey = 'firebase_user_token';
  static const String _userPreferencesKey = 'user_preferences';

  /// Store user authentication token
  Future<void> storeUserToken(String token) async {
    await _storage.write(key: _userTokenKey, value: token);
  }

  /// Retrieve user authentication token
  Future<String?> getUserToken() async {
    return await _storage.read(key: _userTokenKey);
  }

  /// Remove user authentication token
  Future<void> removeUserToken() async {
    await _storage.delete(key: _userTokenKey);
  }

  /// Store user preferences
  Future<void> storeUserPreferences(String preferences) async {
    await _storage.write(key: _userPreferencesKey, value: preferences);
  }

  /// Retrieve user preferences
  Future<String?> getUserPreferences() async {
    return await _storage.read(key: _userPreferencesKey);
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}