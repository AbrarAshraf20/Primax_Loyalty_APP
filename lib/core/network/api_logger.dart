// lib/core/network/api_logger.dart
import '../utils/app_config.dart';

/// Simple logger for API requests and responses
class ApiLogger {
  // Use a simple log method that doesn't rely on specific parameter types
  static void log(String message) {
    if (AppConfig.enableLogging) {
      print(message);
    }
  }

  // Create formatted request log
  static void logRequest(String method, String url, {dynamic body}) {
    if (!AppConfig.enableLogging) return;

    log('🔷 API REQUEST [$method] $url');
    if (body != null) log('Body: $body');
  }

  // Create formatted response log
  static void logResponse(String method, String url, int statusCode, dynamic body) {
    if (!AppConfig.enableLogging) return;

    final emoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
    log('$emoji API RESPONSE [$method] $url → Status: $statusCode');
    log('Response: $body');
  }

  // Create formatted error log
  static void logError(String message, dynamic error, StackTrace? stackTrace) {
    if (!AppConfig.enableLogging) return;

    log('❌ API ERROR: $message');
    log('Error: $error');
    if (stackTrace != null) log('Stack trace: $stackTrace');
  }
}