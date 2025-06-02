// lib/services_service.dart
import 'package:primax/core/di/service_locator.dart';
import 'package:primax/core/network/api_client.dart';
import 'package:primax/core/network/token_manager.dart';
import 'package:primax/models/user_model.dart';

class AuthService {
  final ApiClient _apiClient = locator<ApiClient>();

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await TokenManager.getToken();
    return token != null && token.isNotEmpty;
  }

  // Login
  Future<User?> login({
    required String identifier,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final response = await _apiClient.post(
        '/login',
        body: {
          'identifier': identifier,
          'password': password,
        },
        requiresAuth: false,
      );

      // Extract token from response
      final data = response.data;
      final token = data['token'];
      final refreshToken = data['refresh_token'];

      // Save tokens
      await TokenManager.saveToken(token);
      if (refreshToken != null) {
        await TokenManager.saveRefreshToken(refreshToken);
      }

      // Parse user data
      final userData = data['user'];
      final user = User.fromJson(userData);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Register - Send OTP
  Future<bool> sendOtp({
    required String name,
    required String email,
    required String phoneNumber,
    required String province,
    required String city,
    required String cnic,
    required String shopNumber,
    required String role,
    required String password,
  }) async {
    try {
      // Build request body with only non-empty optional fields
      final body = <String, dynamic>{
        'name': name,
        'email': email,
        'role': role,
        'password': password,
      };
      
      // Add optional fields only if they are not empty
      if (phoneNumber.isNotEmpty) body['phone_number'] = phoneNumber;
      if (province.isNotEmpty) body['province'] = province;
      if (city.isNotEmpty) body['city'] = city;
      if (cnic.isNotEmpty) body['cnic'] = cnic;
      if (shopNumber.isNotEmpty) body['shop_number'] = shopNumber;
      
      final response = await _apiClient.post(
        '/send-otp',
        body: body,
        requiresAuth: false,
      );

      return response.isSuccess;
    } catch (e) {
      rethrow;
    }
  }

  // Register - Verify OTP
  Future<User?> register({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _apiClient.post(
        '/register',
        body: {
          'email': email,
          'otp': otp,
        },
        requiresAuth: false,
      );

      // Extract token from response
      final data = response.data;
      final token = data['token'];
      // final refreshToken = data['refresh_token'];

      // Save tokens
      await TokenManager.saveToken(token);
      // if (token != null) {
      //   await TokenManager.saveRefreshToken(token);
      // }

      // Parse user data
      final userData = data['user'];
      final user = User.fromJson(userData);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<bool> resetPassword({
    required String oldPassword,
    required String newPassword,
    required String reEnterNewPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '/reset-password',
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
          're_enter_new_password': reEnterNewPassword,
        },
      );

      return response.isSuccess;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<bool> logout() async {
    try {
      final response = await _apiClient.post('/logout');

      // Clear tokens regardless of API response
      await TokenManager.clearAll();

      return response.isSuccess;
    } catch (e) {
      // Still clear tokens even if API call fails
      await TokenManager.clearAll();
      rethrow;
    }
  }

  // Auto login with saved credentials
  Future<User?> autoLogin() async {
    // Check if remember me is enabled
    final rememberMe = await TokenManager.isRememberMeEnabled();
    if (!rememberMe) return null;

    // Get saved credentials
    final credentials = await TokenManager.getSavedCredentials();
    if (credentials == null) return null;

    final identifier = credentials['identifier'];
    final password = credentials['password'];

    if (identifier == null || password == null) return null;

    // Try to login with saved credentials
    return await login(
      identifier: identifier,
      password: password,
      rememberMe: true,
    );
  }
  Future<bool> requestPasswordReset(String email) async {
    try {
      final response = await _apiClient.post(
        '/forgot-password',
        body: {'email': email},
        requiresAuth: false,
      );

      return response.isSuccess;
    } catch (e) {
      rethrow;
    }
  }

}