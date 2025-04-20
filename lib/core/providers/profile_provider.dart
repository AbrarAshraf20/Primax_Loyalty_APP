// lib/providers/profile_provider.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:primax/core/network/api_exception.dart';
import 'package:primax/services/profile_service.dart';

import '../../models/user_model.dart';
import '../di/service_locator.dart';
import 'auth_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = locator<ProfileService>();
  final AuthProvider _authProvider = locator<AuthProvider>();

  // State variables
  bool _isLoading = false;
  String _errorMessage = '';
  User? _userProfile;

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  User? get userProfile => _userProfile;
  // List<Address> get addresses => _userProfile?.addresses ?? [];

  // Get profile details
  Future<void> getProfileDetails() async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _profileService.getProfileDetails();
      _userProfile = user;

      // Update auth provider with latest user data
      _authProvider.updateUserData(user);

      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
    }
  }

  // Update profile image
  Future<bool> updateProfileImage(File image) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _profileService.updateProfileImage(image);
      _userProfile = user;

      // Update auth provider with latest user data
      _authProvider.updateUserData(user);

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

  // Update profile
  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String cnic,
    File? image,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _profileService.updateProfile(
        name: name,
        email: email,
        phone: phone,
        cnic: cnic,
        image: image,
      );

      _userProfile = user;

      // Update auth provider with latest user data
      _authProvider.updateUserData(user);

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

  // Add or update address
  // Future<bool> addUpdateAddress({
  //   required String address,
  //   String? street,
  //   String? postcode,
  //   String? apartment,
  //   required String label,
  // }) async {
  //   _setLoading(true);
  //   _clearError();
  //
  //   try {
  //     final newAddress = await _profileService.addUpdateAddress(
  //       address: address,
  //       street: street,
  //       postcode: postcode,
  //       apartment: apartment,
  //       label: label,
  //     );
  //
  //     // Update local user profile with new address
  //     if (_userProfile != null) {
  //       final addresses = List<Address>.from(_userProfile!.addresses);
  //
  //       // Check if address already exists (by ID)
  //       final index = addresses.indexWhere((a) => a.id == newAddress.id);
  //       if (index >= 0) {
  //         // Update existing address
  //         addresses[index] = newAddress;
  //       } else {
  //         // Add new address
  //         addresses.add(newAddress);
  //       }
  //
  //       // Update user profile with new addresses
  //       _userProfile = _userProfile!.copyWith(addresses: addresses);
  //
  //       // Update auth provider with latest user data
  //       _authProvider.updateUserData(_userProfile!);
  //     }
  //
  //     _setLoading(false);
  //     return true;
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

  // Update user points (called from other providers)
  void updatePoints(int points) {
    if (_userProfile != null) {
      // _userProfile = _userProfile!.copyWith(points: points);

      // Update auth provider with latest user data
      _authProvider.updateUserData(_userProfile!);

      notifyListeners();
    }
  }
}