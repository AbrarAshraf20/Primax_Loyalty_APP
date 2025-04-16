// lib/core/network/api_response.dart

/// A class that represents an API response.
/// It includes status code, data, and success flag.
class ApiResponse<T> {
  final int statusCode;
  final T? data;
  final bool isSuccess;

  ApiResponse({
    required this.statusCode,
    this.data,
    required this.isSuccess,
  });

  /// Creates a parsed model from the API response
  /// using the provided parser function
  ApiResponse<R> parseData<R>(R Function(T data) parser) {
    return ApiResponse<R>(
      statusCode: statusCode,
      data: data != null ? parser(data!) : null,
      isSuccess: isSuccess,
    );
  }
}