// lib/core/network/token_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  // Keys for SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _rememberMeKey = 'remember_me';
  static const String _userCredentialsKey = 'user_credentials';
  static const String _userDataKey = 'user_data';

  // Save auth token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get auth token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  // Get refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Save user data (for caching user profile)
  static Future<void> saveUserData(String userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, userData);
  }

  // Get saved user data
  static Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userDataKey);
  }

  // Save user credentials (for remember me)
  static Future<void> saveUserCredentials(
      String identifier,
      String password,
      bool rememberMe
      ) async {
    if (!rememberMe) {
      await clearUserCredentials();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, rememberMe);

    // Only save credentials if remember me is checked
    if (rememberMe) {
      // In a production app, you'd want to encrypt the password
      // This is a simplified implementation
      final credentials = {
        'identifier': identifier,
        'password': password,
      };

      await prefs.setString(_userCredentialsKey,
          credentials.toString()
      );
    }
  }

  // Get saved user credentials
  static Future<Map<String, String>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;

    if (!rememberMe) return null;

    final credentialsStr = prefs.getString(_userCredentialsKey);
    if (credentialsStr == null) return null;

    // Parse the credentials string
    // This is a simple implementation - in production you'd use proper serialization
    try {
      final str = credentialsStr.replaceAll('{', '').replaceAll('}', '');
      final parts = str.split(', ');

      final map = <String, String>{};
      for (var part in parts) {
        final keyValue = part.split(': ');
        if (keyValue.length == 2) {
          map[keyValue[0]] = keyValue[1];
        }
      }

      if (map.containsKey('identifier') && map.containsKey('password')) {
        return map;
      }
    } catch (e) {
      print('Error parsing credentials: $e');
    }

    return null;
  }

  // Check if remember me is enabled
  static Future<bool> isRememberMeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  // Clear user credentials
  static Future<void> clearUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userCredentialsKey);
    await prefs.setBool(_rememberMeKey, false);
  }

  // Clear all tokens and credentials (on logout)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userCredentialsKey);
    await prefs.remove(_userDataKey);
    await prefs.setBool(_rememberMeKey, false);
  }
}