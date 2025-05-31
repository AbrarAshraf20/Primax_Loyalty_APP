// lib/core/network/network_interceptor.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_exception.dart';
import 'token_manager.dart';
import '../utils/app_config.dart';
import '../../services/auth_service.dart';
import '../di/service_locator.dart';

/// Advanced interceptor for network requests
/// Handles token refresh, request/response logging, and error transformation
class NetworkInterceptor {
  static bool _isRetrying = false;
  
  static bool get isRetrying => _isRetrying;
  
  static Future<http.Response> interceptRequest(Future<http.Response> Function() requestFunction) async {
    try {
      // Execute the request
      final response = await requestFunction();

      // Check if token is expired (401 status)
      if (response.statusCode == 401 && !_isRetrying) {
        _isRetrying = true;
        
        // First try to refresh the token
        final refreshed = await _refreshToken();

        if (refreshed) {
          // Retry the original request with the new token
          _isRetrying = false;
          return await requestFunction();
        } else {
          // If refresh failed, try auto-login with saved credentials
          final autoLoginSuccess = await _tryAutoLogin();
          
          if (autoLoginSuccess) {
            // Retry the original request with the new token
            _isRetrying = false;
            return await requestFunction();
          }
        }
        
        _isRetrying = false;
      }

      return response;
    } catch (e) {
      _isRetrying = false;
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
  
  // Attempt to auto-login with saved credentials
  static Future<bool> _tryAutoLogin() async {
    try {
      // Check if remember me is enabled and credentials are saved
      final credentials = await TokenManager.getSavedCredentials();
      if (credentials == null) {
        return false;
      }
      
      final identifier = credentials['identifier'];
      final password = credentials['password'];
      
      if (identifier == null || password == null) {
        return false;
      }
      
      // Perform login using saved credentials
      final authService = locator<AuthService>();
      final user = await authService.login(
        identifier: identifier,
        password: password,
        rememberMe: true,
      );
      
      return user != null;
    } catch (e) {
      print('Auto-login failed: $e');
      return false;
    }
  }
}