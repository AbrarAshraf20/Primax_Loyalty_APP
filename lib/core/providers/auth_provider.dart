// lib/core/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:primax/core/di/service_locator.dart';
import 'package:primax/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../network/api_exception.dart';
import '../network/token_manager.dart';

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

  // Check saved credentials and auto-login if remember me is enabled
  Future<bool> checkSavedCredentials() async {
    _setLoading(true);
    _clearError();

    try {
      // Get saved credentials
      final credentials = await TokenManager.getSavedCredentials();

      if (credentials == null) {
        _setLoading(false);
        return false;
      }

      final identifier = credentials['identifier'];
      final password = credentials['password'];

      if (identifier == null || password == null) {
        _setLoading(false);
        return false;
      }

      // Try to login with saved credentials
      return await login(
        identifier: identifier,
        password: password,
        rememberMe: true,
        silent: true, // Don't show errors for auto-login
      );
    } catch (e) {
      if (!_isSilent) {
        _setError('Auto-login failed');
      }
      _setLoading(false);
      return false;
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
      print('error: $e');
      _setError('An unexpected error occurred $e');
      _setLoading(false);
      return false;
    }
  }

  // Flag to track if we're in a silent auto-login
  bool _isSilent = false;

  // Login
  Future<bool> login({
    required String identifier,
    required String password,
    bool rememberMe = true,
    bool silent = false,
  }) async {
    _setLoading(true);
    _clearError();
    _isSilent = silent;

    try {
      final user = await _authService.login(
        identifier: identifier,
        password: password,
        rememberMe: rememberMe,
      );

      // Save credentials if remember me is checked
      await TokenManager.saveUserCredentials(identifier, password, rememberMe);

      _currentUser = user;
      _isLoggedIn = true;

      _setLoading(false);
      _isSilent = false;
      return true;
    } on ApiException catch (e) {
      if (!silent) {
        _setError(e.message);
      }
      _setLoading(false);
      _isSilent = false;
      return false;
    } catch (e) {
      if (!silent) {
        _setError('An unexpected error occurred');
      }
      _setLoading(false);
      _isSilent = false;
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

        // Clear saved credentials and tokens
        await TokenManager.clearAll();
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
  Future<bool> requestPasswordReset(String email) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.requestPasswordReset(email);

      if (success) {
        // Optional: Store email for later use
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('reset_email', email);
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

  // Delete account
  Future<bool> deleteAccount() async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.deleteAccount();

      if (success) {
        _currentUser = null;
        _isLoggedIn = false;
        
        // Clear all local data
        await TokenManager.clearAll();
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

  // // Reset password with token from email link
  // Future<bool> resetPasswordWithToken({
  //   required String email,
  //   required String token,
  //   required String newPassword,
  //   required String confirmPassword,
  // }) async {
  //   _setLoading(true);
  //   _clearError();
  //
  //   try {
  //     final success = await _authService.resetPasswordWithToken(
  //       email: email,
  //       token: token,
  //       newPassword: newPassword,
  //       confirmPassword: confirmPassword,
  //     );
  //
  //     _setLoading(false);
  //     return success;
  //   } on ApiException catch (e) {
  //     _setError(e.message);
  //     _setLoading(false);
  //     return false;
  //   } catch (e) {
  //     _setError('An unexpected error occurred');
  //     _setLoading(false);
  //     return false;
  //   }
  // }
}