// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:primax/core/di/service_locator.dart';
import 'package:primax/services/auth_service.dart';

import '../../models/user_model.dart';
import '../network/api_exception.dart';


class AuthProvider extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();

  // State variables
  bool _isLoading = false;
  String _errorMessage = '';
  User? _currentUser;
  bool _isLoggedIn = false;

  // Registration data
  String _registrationEmail = '';
  Map<String, String> _registrationData = {};

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  String get registrationEmail => _registrationEmail;

  // Constructor - check login status when initialized
  AuthProvider() {
    _checkLoginStatus();
  }

  // Check if user is logged in
  Future<void> _checkLoginStatus() async {
    _setLoading(true);
    try {
      _isLoggedIn = await _authService.isLoggedIn();

      // If logged in, try to load user data
      if (_isLoggedIn) {
        await refreshUserData();
      }
    } catch (e) {
      _setError('Error checking login status');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh user data from API
  Future<void> refreshUserData() async {
    if (!_isLoggedIn) return;

    // This is actually handled by ProfileProvider, but we
    // might need to update local state here
  }

  // Send OTP for registration
  Future<bool> sendRegistrationOtp({
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
    _setLoading(true);
    _clearError();

    try {
      // Store registration data for later
      _registrationEmail = email;
      _registrationData = {
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
      };

      final success = await _authService.sendOtp(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        province: province,
        city: city,
        cnic: cnic,
        shopNumber: shopNumber,
        address: address,
        role: role,
        password: password,
      );

      _setLoading(false);
      return success;
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
      return false;
    }
  }

  // Register with OTP
  Future<bool> register(String otp) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authService.register(
        email: _registrationEmail,
        otp: otp,
      );

      _currentUser = user;
      _isLoggedIn = true;

      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
      return false;
    }
  }

  // Login
  Future<bool> login({
    required String identifier,
    required String password,
    bool rememberMe = true,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authService.login(
        identifier: identifier,
        password: password,
        rememberMe: rememberMe,
      );

      _currentUser = user;
      _isLoggedIn = true;

      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
      return false;
    }
  }

  // Logout
  Future<bool> logout() async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.logout();

      if (success) {
        _currentUser = null;
        _isLoggedIn = false;
      }

      _setLoading(false);
      return success;
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword({
    required String oldPassword,
    required String newPassword,
    required String reEnterNewPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.resetPassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        reEnterNewPassword: reEnterNewPassword,
      );

      _setLoading(false);
      return success;
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
      return false;
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
  }

  // Update user data (called from ProfileProvider)
  void updateUserData(User user) {
    _currentUser = user;
    notifyListeners();
  }
}