class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final Map<String, List<String>> validationErrors;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
    Map<String, List<String>>? validationErrors,
  }) : this.validationErrors = validationErrors ?? {};

  // Helper to check if this is a validation error
  bool get isValidationError => statusCode == 422;

  // Get validation error for a specific field
  String? getFieldError(String field) {
    if (validationErrors.containsKey(field) && validationErrors[field]!.isNotEmpty) {
      return validationErrors[field]!.first;
    }
    return null;
  }

  @override
  String toString() {
    return 'ApiException: $message (Status: ${statusCode ?? 'unknown'})';
  }
}