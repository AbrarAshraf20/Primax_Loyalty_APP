// lib/services/lucky_draw_service.dart
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../models/lucky_draw.dart';

class LuckyDrawService {
  final ApiClient _apiClient = ApiClient();

  // Get all lucky draws
  Future<List<LuckyDraw>> getLuckyDraws() async {
    try {
      final response = await _apiClient.get(
        '/lucky-draws',
        requiresAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> drawsData = response.data['data'] ?? [];
        return drawsData
            .map((item) => LuckyDraw.fromJson(item))
            .toList();
      } else {
        throw ApiException(message: 'Failed to load lucky draws');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  // Enter a lucky draw
  Future<bool> enterLuckyDraw(int drawId, Map<String, String> paymentInfo, String cashornot) async {
    try {
      // Prepare the body with draw ID and payment information
      Map<String, dynamic> body = {
        'lucky_draw_id': drawId,
        'cash_or_non_cash': cashornot,
      };

      // Check if cash prize or non-cash prize
      if (cashornot == "1") {
        // Cash prize - send payment information
        body['payment_method'] = paymentInfo['method'] ?? ''; // Easypase jazz cash
        body['account_holder_name'] = paymentInfo['accountHolderName'] ?? ''; // Name of the account holder
        body['account_number'] = paymentInfo['accountNumber'] ?? '';
        body['person_name'] = '';
        body['person_address'] = '';
        body['person_phone'] = '';
        
        // Add bank name if payment method is bank account
        if (paymentInfo['method'] == 'bankAccount' && paymentInfo.containsKey('bankName')) {
          body['bank_name'] = paymentInfo['bankName']!;
        }
      } else {
        // Non-cash prize - send delivery information
        body['payment_method'] = '';
        body['account_holder_name'] = '';
        body['account_number'] = '';
        body['person_name'] = paymentInfo['name'] ?? '';
        body['person_address'] = paymentInfo['address'] ?? '';
        body['person_phone'] = paymentInfo['contactNumber'] ?? '';
      }

      final response = await _apiClient.post(
        '/enter-user',
        body: body,
        requiresAuth: true,
      );

      return response.isSuccess;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  // Get lucky draw winners
  Future<List<Map<String, dynamic>>> getLuckyDrawWinners(int drawId) async {
    try {
      final response = await _apiClient.get(
        '/lucky-draws/$drawId/winners',
        requiresAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> winnersData = response.data['data'] ?? [];
        return winnersData.cast<Map<String, dynamic>>();
      } else {
        throw ApiException(message: 'Failed to load winners');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred: ${e.toString()}');
    }
  }
}