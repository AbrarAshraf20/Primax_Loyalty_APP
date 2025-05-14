// lib/providers/profile_provider.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:primax/core/network/api_exception.dart';
import 'package:primax/models/address_model.dart';
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
  List<Address> _addresses = [];
  bool _addressesLoaded = false;
  Map<String, List<String>> _validationErrors = {};

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  User? get userProfile => _userProfile;
  List<Address> get addresses => _addresses;
  bool get addressesLoaded => _addressesLoaded;
  Map<String, List<String>> get validationErrors => _validationErrors;

  // Get error for a specific field
  String? getFieldError(String field) {
    if (_validationErrors.containsKey(field) && _validationErrors[field]!.isNotEmpty) {
      return _validationErrors[field]!.first;
    }
    return null;
  }

  // Get drawer details
  Future<void> getProfileDetails() async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _profileService.getProfileDetails();
      _userProfile = user;
      print('user drawer $_userProfile');
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

  // Get user addresses
  Future<void> getAddresses() async {
    // Remove the condition that prevents reloading to ensure we get fresh data
    // if (_addressesLoaded && _addresses.isNotEmpty) return;

    _setLoading(true);
    _clearError();

    try {
      final addressList = await _profileService.getAddresses();
      print('✅ Fetched addresses: $addressList'); // Debug print

      _addresses = addressList;
      _addressesLoaded = true;
      _setLoading(false);
    } on ApiException catch (e) {
      print('❌ API Exception while fetching addresses: ${e.message}'); // Debug print
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      print('❌ Error while fetching addresses: $e'); // Debug print
      _setError('An unexpected error occurred while fetching addresses');
      _setLoading(false);
    }
  }

  // Update drawer image
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

  // Update drawer
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

      // Store validation errors
      if (e.isValidationError && e.validationErrors.isNotEmpty) {
        _validationErrors = e.validationErrors;
      } else {
        _clearValidationErrors();
      }

      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred');
      _clearValidationErrors();
      _setLoading(false);
      return false;
    }
  }

  // Add a new address
  Future<bool> addAddress({
    required String street,
    required String address,
    required String postalCode,
    required String label,
    required String apartment,
    String state = "", // Kept for backward compatibility
    String? latitude,
    String? longitude,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final newAddress = await _profileService.addAddress(
        street: street,
        address: address,
        postalCode: postalCode,
        label: label,
        apartment: apartment,
        latitude: latitude,
        longitude: longitude,
      );

      // Add the new address to the list
      _addresses.add(newAddress);

      // If this is the default address, update other addresses
      // if (isDefault) {
        for (int i = 0; i < _addresses.length - 1; i++) {
          if (_addresses[i].isDefault) {
            _addresses[i] = _addresses[i].copyWith(isDefault: false);
          }
        // }
      }

      notifyListeners();
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

  // Update an existing address
  Future<bool> updateAddress({
    required int addressId,
    required String street,
    required String address,
    required String postalCode,
    required String label,
    required String apartment,
    String state = "", // Kept for backward compatibility
    String? latitude,
    String? longitude,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedAddress = await _profileService.updateAddress(
        addressId: addressId, // Fixed: was hardcoded to 1
        street: street,
        address: address,
        postalCode: postalCode,
        label: label,
        apartment: apartment,
        latitude: latitude,
        longitude: longitude,
      );

      // Find and update the address in the list
      final index = _addresses.indexWhere((a) => a.id == addressId);
      if (index >= 0) {
        _addresses[index] = updatedAddress;

        // If this is the default address, update other addresses
        // if (isDefault) {
          for (int i = 0; i < _addresses.length; i++) {
            if (i != index && _addresses[i].isDefault) {
              _addresses[i] = _addresses[i].copyWith(isDefault: false);
            }
          }
        // }
      }

      notifyListeners();
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

  // Delete an address
  Future<bool> deleteAddress(int addressId) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _profileService.deleteAddress(addressId);
      
      if (success) {
        // Remove the address from the list
        _addresses.removeWhere((a) => a.id == addressId);
        notifyListeners();
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

  void _clearValidationErrors() {
    _validationErrors = {};
  }

  // Public method to clear all errors before form submission
  void clearAllErrors() {
    _clearError();
    _clearValidationErrors();
    notifyListeners();
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