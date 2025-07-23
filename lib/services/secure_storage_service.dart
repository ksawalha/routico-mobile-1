import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles secure storage of sensitive data
class SecureStorageService {
  static const String _tokenKey = 'jwt_token';
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  /// Stores token securely and maintains legacy storage for compatibility
  static Future<void> storeToken(String token) async {
    // Store in secure storage
    await _storage.write(key: _tokenKey, value: token);
    
    // Also store in SharedPreferences for backward compatibility
    // This can be removed in future versions
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Retrieves token, preferring secure storage
  static Future<String?> getToken() async {
    // Try to get from secure storage first
    String? token = await _storage.read(key: _tokenKey);
    
    // If not found, try shared preferences as fallback
    if (token == null) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString(_tokenKey);
      
      // If found in SharedPreferences, migrate to secure storage
      if (token != null) {
        await _storage.write(key: _tokenKey, value: token);
      }
    }
    
    return token;
  }

  /// Deletes token from all storage locations
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Checks if token exists
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}