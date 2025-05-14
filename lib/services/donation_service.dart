// lib/services/donation_service.dart
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../models/foundation.dart';

class DonationService {
  final ApiClient _apiClient = ApiClient();

  // Get all foundations
  Future<List<Foundation>> getFoundations() async {
    try {
      final response = await _apiClient.get(
        '/foundations',
        requiresAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> foundationsData = response.data['data'] ?? [];
        return foundationsData
            .map((item) => Foundation.fromJson(item))
            .toList();
      } else {
        throw ApiException(message: 'Failed to load foundations');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  // Make a donation
  Future<Map<String, dynamic>> makeDonation({
    required int foundationId,
    required int amount,
    required String name,
    required String message,
  }) async {
    try {
      final response = await _apiClient.post(
        '/donate',
        body: {
          'foundation_id': foundationId,
          'amount': amount,
          'name': name,
          'message': message,
        },
      );

      if (response.isSuccess) {
        return {
          'success': true,
          'message': response.data?['message'] ?? 'Donation successful',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to process donation',
        };
      }
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }
}