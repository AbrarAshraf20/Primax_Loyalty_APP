// lib/core/utils/app_config.dart
// lib/core/utils/app_config.dart

/// Configuration class for app-wide settings
class AppConfig {
  // API settings
  static const String apiBaseUrl = 'https://primaxloyaltyprogram.com/api'; // Replace with your actual API base URL for production
  static const String imageBaseUrl = 'https://primaxloyaltyprogram.com/'; // Replace with your actual API base URL for production
  // static const String apiBaseUrl = 'https://dashboard.primaxsolarenergy.com/api'; // Replace with your actual API base URL for production
  static const int defaultRequestTimeoutSeconds = 30;

  // Environment settings
  static const bool isDebugMode = true; // Set to false for production

  // Feature flags
  static const bool enableLogging = true;

  // Use mock API (for development/testing)
  static const bool useMockApi = false;
}