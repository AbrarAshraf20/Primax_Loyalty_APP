// lib/services/auth_service.dart
import 'dart:convert';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/network/token_manager.dart';
import '../core/di/service_locator.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _apiClient = locator<ApiClient>();

  // Send OTP for registration
  Future<bool> sendOtp({
    required String name,
    required String email,
    required String phoneNumber,
    required String province,
    required String city,
    required String cnic,
    required String shopNumber,
    required String address,
    required String role,
    required String password,
  }) async {
    try {
      final response = await _apiClient.postFormData(
        '/send-otp',
        fields: {
          'name': name,
          'email': email,
          'phone_number': phoneNumber,
          'province': province,
          'city': city,
          'cnic': cnic,
          'shop_number': shopNumber,
          'address': address,
          'role': role,
          'password': password,
        },
        requiresAuth: false,
      );

      return response.isSuccess;
    } on ApiException {
      rethrow;
    }
  }

  // Register user with OTP
  Future<User> register({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _apiClient.postFormData(
        '/register',
        fields: {
          'email': email,
          'otp': otp,
        },
        requiresAuth: false,
      );

      if (response.data != null) {
        final userData = response.data['user'];
        final token = response.data['token'];

        // Save token
        if (token != null) {
          await TokenManager.saveToken(token);
        }

        // Create and return user
        final user = User.fromJson(userData);

        // Save user data for offline use
        await TokenManager.saveUserData(jsonEncode(userData));

        return user;
      } else {
        throw ApiException(message: 'Invalid response from server');
      }
    } on ApiException {
      rethrow;
    }
  }

  // Login user
  Future<User> login({
    required String identifier,
    required String password,
    bool rememberMe = true,
  }) async {
    try {
      final response = await _apiClient.post(
        '/login',
        body: {
          'identifier': identifier,
          'password': password,
          'remember_me': rememberMe,
        },
        requiresAuth: false,
      );

      if (response.data != null) {
        final userData = response.data['user'];
        final token = response.data['token'];

        // Save token
        if (token != null) {
          await TokenManager.saveToken(token);
        }

        // Create and return user
        final user = User.fromJson(userData);

        // Save user data for offline use
        await TokenManager.saveUserData(jsonEncode(userData));

        return user;
      } else {
        throw ApiException(message: 'Invalid response from server');
      }
    } on ApiException {
      rethrow;
    }
  }

  // Logout user
  Future<bool> logout() async {
    try {
      final response = await _apiClient.post('/logout');

      // Clear token regardless of response
      await TokenManager.clearAll();

      return response.isSuccess;
    } catch (e) {
      // Clear token even if request fails
      await TokenManager.clearAll();

      // Only rethrow if it's not a network error
      if (e is ApiException) {
        rethrow;
      }

      // Return true for network errors to indicate successful local logout
      return true;
    }
  }

  // Reset password
  Future<bool> resetPassword({
    required String oldPassword,
    required String newPassword,
    required String reEnterNewPassword,
  }) async {
    try {
      if (newPassword != reEnterNewPassword) {
        throw ApiException(message: "Passwords don't match");
      }

      final response = await _apiClient.postFormData(
        '/reset-password',
        fields: {
          'old_password': oldPassword,
          'new_password': newPassword,
          're_enter_new_password': reEnterNewPassword,
        },
      );

      return response.isSuccess;
    } on ApiException {
      rethrow;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() {
    return TokenManager.isLoggedIn();
  }
}