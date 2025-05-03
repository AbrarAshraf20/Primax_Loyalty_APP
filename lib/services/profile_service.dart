// lib/services/profile_service.dart
import 'dart:io';
import 'dart:convert';

import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/network/token_manager.dart';
import '../core/di/service_locator.dart';
import '../models/user_model.dart';

class ProfileService {
  final ApiClient _apiClient = locator<ApiClient>();

  // Get user profile details
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

  // Update profile image
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

  // Update profile details
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

// // Add or update address
// Future<Address> addUpdateAddress({
//   required String address,
//   String? street,
//   String? postcode,
//   String? apartment,
//   required String label,
// }) async {
//   try {
//     final fields = {
//       'address': address,
//       'label': label,
//     };
//
//     if (street != null) fields['street'] = street;
//     if (postcode != null) fields['postcode'] = postcode;
//     if (apartment != null) fields['apartment'] = apartment;
//
//     final response = await _apiClient.postFormData(
//       '/address',
//       fields: fields,
//     );
//
//     if (response.data != null) {
//       final addressData = response.data['address'] ?? response.data;
//
//       // Create and return address
//       final newAddress = Address.fromJson(addressData);
//
//       // Update cached user data with new address
//       final cachedUserData = await TokenManager.getUserData();
//       if (cachedUserData != null) {
//         final userData = jsonDecode(cachedUserData);
//
//         // Add or update the address in the list
//         List<dynamic> addresses = userData['addresses'] ?? [];
//         bool found = false;
//
//         for (int i = 0; i < addresses.length; i++) {
//           if (addresses[i]['id'] == newAddress.id) {
//             addresses[i] = newAddress.toJson();
//             found = true;
//             break;
//           }
//         }
//
//         if (!found) {
//           addresses.add(newAddress.toJson());
//         }
//
//         userData['addresses'] = addresses;
//         await TokenManager.saveUserData(jsonEncode(userData));
//       }
//
//       return newAddress;
//     } else {
//       throw ApiException(message: 'Invalid response from server');
//     }
//   } on ApiException {
//     rethrow;
//   }
// }
}