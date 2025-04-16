// lib/core/network/network_interceptor.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_exception.dart';
import 'token_manager.dart';
import '../utils/app_config.dart';

/// Advanced interceptor for network requests
/// Handles token refresh, request/response logging, and error transformation
class NetworkInterceptor {
  static Future<http.Response> interceptRequest(Future<http.Response> Function() requestFunction) async {
    try {
      // Execute the request
      final response = await requestFunction();

      // Check if token is expired (401 status)
      if (response.statusCode == 401) {
        // Try to refresh the token
        final refreshed = await _refreshToken();

        if (refreshed) {
          // Retry the original request with the new token
          return await requestFunction();
        }
      }

      return response;
    } catch (e) {
      // Transform generic errors into ApiExceptions
      if (e is! ApiException) {
        throw ApiException(message: 'Network error: ${e.toString()}');
      }
      rethrow;
    }
  }

  // Attempt to refresh the token
  static Future<bool> _refreshToken() async {
    try {
      final refreshToken = await TokenManager.getRefreshToken();

      if (refreshToken == null) {
        return false;
      }

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newToken = data['access_token'];
        final newRefreshToken = data['refresh_token'];

        await TokenManager.saveToken(newToken);
        await TokenManager.saveRefreshToken(newRefreshToken);

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}