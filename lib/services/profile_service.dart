// lib/services/profile_service.dart
import 'dart:io';
import 'dart:convert';

import 'package:primax/models/address_model.dart';

import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/network/token_manager.dart';
import '../core/di/service_locator.dart';
import '../models/user_model.dart';

class ProfileService {
  final ApiClient _apiClient = locator<ApiClient>();

  // Get user drawer details
  Future<User> getProfileDetails() async {
    try {
      final response = await _apiClient.get('/profile-details');

      if (response.data != null) {
        final userData = response.data['user'] ?? response.data;

        // Create and return user
        final user = User.fromJson(userData);

        // Save user data for offline use
        await TokenManager.saveUserData(jsonEncode(userData));

        return user;
      } else {
        throw ApiException(message: 'Invalid response from server');
      }
    } on ApiException {
      // Try to get cached user data if network request fails
      final cachedUserData = await TokenManager.getUserData();
      if (cachedUserData != null) {
        return User.fromJson(jsonDecode(cachedUserData));
      }
      rethrow;
    }
  }

  // Get user addresses
  Future<List<Address>> getAddresses() async {
    try {
      final response = await _apiClient.get('/get-address');
      print('📡 API Response: ${response.data}'); // Debug print full response

      if (response.data != null) {
        // Use the new unified parseAddresses method that handles all response formats
        final addresses = Address.parseAddresses(response.data);
        print('📌 Parsed ${addresses.length} addresses: $addresses'); // Debug print
        return addresses;
      } else {
        throw ApiException(message: 'Invalid response from server');
      }
    } on ApiException catch (e) {
      print('❌ API Exception in getAddresses: ${e.message}'); // Debug print
      rethrow;
    } catch (e) {
      print('❌ Unexpected error in getAddresses: $e'); // Debug print
      throw ApiException(message: 'Error processing address data: $e');
    }
  }

  // Update drawer image
  Future<User> updateProfileImage(File image) async {
    try {
      final response = await _apiClient.postFormData(
        '/profile-image',
        files: [MapEntry('image', image)],
        fields: {},
      );

      if (response.data != null) {
        final userData = response.data['user'] ?? response.data;

        // Create and return user
        final user = User.fromJson(userData);

        // Save updated user data
        await TokenManager.saveUserData(jsonEncode(userData));

        return user;
      } else {
        throw ApiException(message: 'Invalid response from server');
      }
    } on ApiException {
      rethrow;
    }
  }

  // Update drawer details
  Future<User> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String cnic,
    File? image,
  }) async {
    try {
      final fields = {
        'name': name,
        'email': email,
        'phone': phone,
        'cnic': cnic,
      };

      List<MapEntry<String, File>>? files;
      if (image != null) {
        files = [MapEntry('image', image)];
      }

      final response = await _apiClient.postFormData(
        '/profile-update',
        fields: fields,
        files: files,
      );

      if (response.data != null) {
        final userData = response.data['user'] ?? response.data;

        // Create and return user
        final user = User.fromJson(userData);

        // Save updated user data
        await TokenManager.saveUserData(jsonEncode(userData));

        return user;
      } else {
        throw ApiException(message: 'Invalid response from server');
      }
    } on ApiException {
      rethrow;
    }
  }

  // Add a new address
  Future<Address> addAddress({
    required String street,
    required String address,
    required String postalCode,
    required String label,
    required String apartment,
    String? latitude,
    String? longitude,
  }) async {
    try {
      final fields = {
        'street': street,
        'address': address,
        'postcode': postalCode,
        'apartment': apartment,
        'label': label,
        // Include location coordinates if available
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };

      final response = await _apiClient.post(
        '/address',
        body: fields,
      );

      if (response.data != null) {
        // Use new parseAddresses method to handle different response formats
        final addresses = Address.parseAddresses(response.data);
        if (addresses.isNotEmpty) {
          return addresses.first;
        } else {
          throw ApiException(message: 'Invalid address data in response');
        }
      } else {
        throw ApiException(message: 'Invalid response from server');
      }
    } on ApiException {
      rethrow;
    }
  }

  // Update an existing address
  Future<Address> updateAddress({
    required int addressId,
    required String street,
    required String address,
    required String postalCode,
    required String label,
    required String apartment,
    String? latitude,
    String? longitude,
  }) async {
    try {
      final fields = {
        'id': addressId.toString(),
        'street': street,
        'address': address,
        'postcode': postalCode,
        'apartment': apartment,
        'label': label,
        // Include location coordinates if available
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };

      final response = await _apiClient.put(
        '/address/$addressId',
        body: fields,
      );

      if (response.data != null) {
        // Use new parseAddresses method to handle different response formats
        final addresses = Address.parseAddresses(response.data);
        if (addresses.isNotEmpty) {
          return addresses.first;
        } else {
          throw ApiException(message: 'Invalid address data in response');
        }
      } else {
        throw ApiException(message: 'Invalid response from server');
      }
    } on ApiException {
      rethrow;
    }
  }

  // Delete an address
  Future<bool> deleteAddress(int addressId) async {
    try {
      final response = await _apiClient.delete('/address/$addressId');
      return response.isSuccess;
    } on ApiException {
      rethrow;
    }
  }
}