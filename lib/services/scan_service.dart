// lib/services/scan_service.dart
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/di/service_locator.dart';

class ScanService {
  final ApiClient _apiClient = locator<ApiClient>();

  // Scan a barcode and earn points
  Future<Map<String, dynamic>> scanBarcode(String barcode) async {
    try {
      final response = await _apiClient.postFormData(
        '/scan',
        fields: {
          'barcode': barcode,
        },
      );

      if (response.data != null) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Scan successful',
          // 'pointsEarned': response.data['points'] ?? 0,
          // 'totalPoints': response.data['total_points'] ?? 0,
        };
      } else {
        return {
          'success': true,
          'message': 'Scan successful',
          'pointsEarned': 0,
          'totalPoints': 0,
        };
      }
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
      };
    }
  }

  // Verify serial number (this is for the VerifySerial screen in your project)
  Future<bool> verifySerial({
    required String name,
    required String mobile,
    required String item,
    required String city,
    required String customerName,
    required String customerContactInfo,
    required String customerAddress,
    required String remarks,
    // You might need to add parameters for the uploaded pics of installation site
  }) async {
    try {
      // Note: This endpoint isn't in your Postman collection,
      // so we're creating a hypothetical implementation
      final response = await _apiClient.postFormData(
        '/verify-serial',
        fields: {
          'name': name,
          'mobile': mobile,
          'item': item,
          'city': city,
          'customer_name': customerName,
          'customer_contact_info': customerContactInfo,
          'customer_address': customerAddress,
          'remarks': remarks,
        },
        // You might need to add files parameter for installation site pictures
      );

      return response.isSuccess;
    } on ApiException {
      rethrow;
    }
  }
}