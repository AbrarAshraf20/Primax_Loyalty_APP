// lib/services/scan_service.dart
import 'dart:io';

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
          'barcode': response.data['barcode'] ?? barcode,
          'pointsEarned': response.data['points'] ?? 0,
          'totalPoints': response.data['total_points'] ?? 0,
        };
      } else {
        return {
          'success': true,
          'message': 'Scan successful',
          'barcode': barcode,
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
  Future<Map<String, dynamic>> verifySerial({
    required String serialNumber,  // Added serial number parameter
    required String name,
    required String mobile,
    required String item,
    required String city,
    required String customerName,
    required String customerContactInfo,
    required String customerAddress,
    required String remarks,
    required String cnic,
    required String serialNum,
    required File image,
  }) async {
    try {
      final response = await _apiClient.postFormData(
        '/verify-serial',
        fields: {
          'barcode': serialNumber, // Include the scan number in the API call
          // 'name': name,
          'mobile': mobile,
          'product_name': item,
          'city': city,
          'customer_name': customerName,
          'customer_contact_info': customerContactInfo,
          'customer_address': customerAddress,
          'remarks': remarks,
          'cnic': cnic,
          'serial_num': serialNum,
        },
        files: [MapEntry('image', image)],
      );

      if (response.isSuccess) {
        // Return the entire response data to get the success message
        return {
          'success': true,
          'message': response.data?['message'] ?? 'Verification successful',
          'barcode': response.data?['barcode'] ?? serialNumber,
        };
      } else {
        return {
          'success': false,
          'message': 'Verification failed',
        };
      }
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
      };
    }
  }
}