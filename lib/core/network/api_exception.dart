// lib/core/network/api_exception.dart

/// Custom exception class for API errors
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  ApiException({
    this.statusCode,
    required this.message,
    this.data,
  });

  @override
  String toString() {
    return 'ApiException: ${statusCode != null ? '[$statusCode] ' : ''}$message';
  }
}