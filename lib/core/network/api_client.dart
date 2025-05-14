// lib/core/network/api_client.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async'; // Add this import for TimeoutException
import 'package:http/http.dart' as http;
import '../utils/app_config.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'token_manager.dart';

class ApiClient {
  // Singleton pattern
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final String baseUrl = AppConfig.apiBaseUrl;

  // Default headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Get authenticated headers (with token)
  Future<Map<String, String>> get _authHeaders async {
    String? token = await TokenManager.getToken();
    return {
      ..._headers,
      'Authorization': 'Bearer $token',
    };
  }

  // Simple logging function
  void _log(String message) {
    if (AppConfig.enableLogging) {
      print(message);
    }
  }

  // Generic GET request
  Future<ApiResponse> get(
      String endpoint, {
        Map<String, dynamic>? queryParams,
        bool requiresAuth = true,
        int timeoutSeconds = 30,
      }) async {
    try {
      final headers = requiresAuth ? await _authHeaders : _headers;

      // Convert queryParams to String values if needed
      final stringQueryParams = queryParams?.map(
              (key, value) => MapEntry(key, value?.toString() ?? '')
      );

      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: stringQueryParams,
      );

      _log('🔷 API REQUEST [GET] $uri');
      if (queryParams != null) _log('Query Params: $queryParams');

      final response = await http.get(
        uri,
        headers: headers,
      ).timeout(Duration(seconds: timeoutSeconds));

      _log('✅ API RESPONSE [GET] $uri → Status: ${response.statusCode}');
      _log('Response: ${response.body}');

      return _processResponse(response);
    } on SocketException {
      final error = ApiException(message: 'No internet connection');
      _log('❌ API ERROR: No internet connection');
      throw error;
    } on TimeoutException {
      final error = ApiException(message: 'Request timeout');
      _log('❌ API ERROR: Request timeout');
      throw error;
    } catch (e, stackTrace) {
      final error = e is ApiException ? e : ApiException(message: e.toString());
      _log('❌ API ERROR: ${error.message}');
      throw error;
    }
  }

  // Generic POST request with JSON body
  Future<ApiResponse> post(
      String endpoint, {
        Map<String, dynamic>? body,
        bool requiresAuth = true,
        int timeoutSeconds = 30,
      }) async {
    try {
      final headers = requiresAuth ? await _authHeaders : _headers;
      final uri = Uri.parse('$baseUrl$endpoint');
      final encodedBody = body != null ? json.encode(body) : null;

      _log('🔷 API REQUEST [POST] $uri');
      if (body != null) _log('Body: $body');

      final response = await http.post(
        uri,
        headers: headers,
        body: encodedBody,
      ).timeout(Duration(seconds: timeoutSeconds));

      _log('✅ API RESPONSE [POST] $uri → Status: ${response.statusCode}');
      _log('Response: ${response.body}');

      return _processResponse(response);
    } on SocketException {
      final error = ApiException(message: 'No internet connection');
      _log('❌ API ERROR: No internet connection');
      throw error;
    } on TimeoutException {
      final error = ApiException(message: 'Request timeout');
      _log('❌ API ERROR: Request timeout');
      throw error;
    } catch (e, stackTrace) {
      final error = e is ApiException ? e : ApiException(message: e.toString());
      _log('❌ API ERROR: ${error.message}');
      throw error;
    }
  }

  // POST request with form data
  Future<ApiResponse> postFormData(
      String endpoint, {
        required Map<String, String> fields,
        List<MapEntry<String, File>>? files,
        bool requiresAuth = true,
        int timeoutSeconds = 60,
      }) async {
    try {
      final headers = requiresAuth ? await _authHeaders : <String, String>{};
      // Remove Content-Type header as multipart will set it
      headers.remove('Content-Type');

      final uri = Uri.parse('$baseUrl$endpoint');

      _log('🔷 API REQUEST [POST FormData] $uri');
      _log('Fields: $fields');

      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);
      request.fields.addAll(fields);

      // Add files if any
      if (files != null) {
        for (var fileEntry in files) {
          final file = fileEntry.value;
          final field = fileEntry.key;
          final fileName = file.path.split('/').last;

          final multipartFile = await http.MultipartFile.fromPath(
            field,
            file.path,
            filename: fileName,
          );

          request.files.add(multipartFile);
        }
      }

      final streamedResponse = await request.send()
          .timeout(Duration(seconds: timeoutSeconds));

      final response = await http.Response.fromStream(streamedResponse);

      _log('✅ API RESPONSE [POST FormData] $uri → Status: ${response.statusCode}');
      _log('Response: ${response.body}');

      return _processResponse(response);
    } on SocketException {
      final error = ApiException(message: 'No internet connection');
      _log('❌ API ERROR: No internet connection');
      throw error;
    } on TimeoutException {
      final error = ApiException(message: 'Request timeout');
      _log('❌ API ERROR: Request timeout');
      throw error;
    } catch (e, stackTrace) {
      final error = e is ApiException ? e : ApiException(message: e.toString());
      _log('❌ API ERROR: ${error.message}');
      throw error;
    }
  }

  // Generic PUT request
  Future<ApiResponse> put(
      String endpoint, {
        Map<String, dynamic>? body,
        bool requiresAuth = true,
        int timeoutSeconds = 30,
      }) async {
    try {
      final headers = requiresAuth ? await _authHeaders : _headers;
      final uri = Uri.parse('$baseUrl$endpoint');
      final encodedBody = body != null ? json.encode(body) : null;

      _log('🔷 API REQUEST [PUT] $uri');
      if (body != null) _log('Body: $body');

      final response = await http.put(
        uri,
        headers: headers,
        body: encodedBody,
      ).timeout(Duration(seconds: timeoutSeconds));

      _log('✅ API RESPONSE [PUT] $uri → Status: ${response.statusCode}');
      _log('Response: ${response.body}');

      return _processResponse(response);
    } on SocketException {
      final error = ApiException(message: 'No internet connection');
      _log('❌ API ERROR: No internet connection');
      throw error;
    } on TimeoutException {
      final error = ApiException(message: 'Request timeout');
      _log('❌ API ERROR: Request timeout');
      throw error;
    } catch (e, stackTrace) {
      final error = e is ApiException ? e : ApiException(message: e.toString());
      _log('❌ API ERROR: ${error.message}');
      throw error;
    }
  }

  // Generic DELETE request
  Future<ApiResponse> delete(
      String endpoint, {
        Map<String, dynamic>? body,
        bool requiresAuth = true,
        int timeoutSeconds = 30,
      }) async {
    try {
      final headers = requiresAuth ? await _authHeaders : _headers;
      final uri = Uri.parse('$baseUrl$endpoint');
      final encodedBody = body != null ? json.encode(body) : null;

      _log('🔷 API REQUEST [DELETE] $uri');
      if (body != null) _log('Body: $body');

      final response = await http.delete(
        uri,
        headers: headers,
        body: encodedBody,
      ).timeout(Duration(seconds: timeoutSeconds));

      _log('✅ API RESPONSE [DELETE] $uri → Status: ${response.statusCode}');
      _log('Response: ${response.body}');

      return _processResponse(response);
    } on SocketException {
      final error = ApiException(message: 'No internet connection');
      _log('❌ API ERROR: No internet connection');
      throw error;
    } on TimeoutException {
      final error = ApiException(message: 'Request timeout');
      _log('❌ API ERROR: Request timeout');
      throw error;
    } catch (e, stackTrace) {
      final error = e is ApiException ? e : ApiException(message: e.toString());
      _log('❌ API ERROR: ${error.message}');
      throw error;
    }
  }

  // Process HTTP response
  ApiResponse _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body.isNotEmpty ? json.decode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      // Success response
      return ApiResponse(
        statusCode: statusCode,
        data: responseBody,
        isSuccess: true,
      );
    } else {
      // Error response
      String errorMessage = 'Unknown error occurred';
      Map<String, List<String>> validationErrors = {};

      if (responseBody != null && responseBody is Map) {
        // Handle regular error messages
        if (responseBody.containsKey('message')) {
          errorMessage = responseBody['message'];
        } else if (responseBody.containsKey('error')) {
          errorMessage = responseBody['error'];
        } else if (responseBody.containsKey('status') && responseBody['status'] == 'error') {
          errorMessage = 'Validation error occurred';
        }

        // Extract validation errors (used on 422 status code)
        if (statusCode == 422 && responseBody.containsKey('errors')) {
          final errors = responseBody['errors'];
          if (errors is Map) {
            errors.forEach((field, messages) {
              if (messages is List) {
                validationErrors[field] = List<String>.from(messages);
              } else if (messages is String) {
                validationErrors[field] = [messages];
              }
            });

            // Create a user-friendly error message from the first validation error
            if (validationErrors.isNotEmpty) {
              final firstField = validationErrors.keys.first;
              final firstError = validationErrors[firstField]!.first;
              errorMessage = firstError;
            }
          }
        }
      }

      throw ApiException(
        statusCode: statusCode,
        message: errorMessage,
        data: responseBody,
        validationErrors: validationErrors,
      );
    }
  }
}