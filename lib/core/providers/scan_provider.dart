// lib/providers/scan_provider.dart
import 'package:flutter/foundation.dart';
import 'package:primax/core/di/service_locator.dart';
import 'package:primax/services/scan_service.dart';
import '../network/api_exception.dart';
import 'profile_provider.dart';

class ScanProvider extends ChangeNotifier {
  final ScanService _scanService = locator<ScanService>();
  final ProfileProvider _profileProvider = locator<ProfileProvider>();

  // State variables
  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';
  int _lastPointsEarned = 0;

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  int get lastPointsEarned => _lastPointsEarned;

  // Scan a barcode
  Future<bool> scanBarcode(String barcode) async {
    _setLoading(true);
    _clearMessages();

    try {
      final result = await _scanService.scanBarcode(barcode);

      if (result['success'] == true) {
        _successMessage = result['message'] ?? 'Scan successful';
        _lastPointsEarned = result['pointsEarned'] ?? 0;

        // Update profile provider with new points total if available
        if (result['totalPoints'] != null) {
          _profileProvider.updatePoints(result['totalPoints']);
        } else {
          // Refresh profile to get updated points
          await _profileProvider.getProfileDetails();
        }

        _setLoading(false);
        return true;
      } else {
        _setError(result['message'] ?? 'Scan failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
      return false;
    }
  }

  // Verify serial
  Future<bool> verifySerial({
    required String name,
    required String mobile,
    required String item,
    required String city,
    required String customerName,
    required String customerContactInfo,
    required String customerAddress,
    required String remarks,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      final success = await _scanService.verifySerial(
        name: name,
        mobile: mobile,
        item: item,
        city: city,
        customerName: customerName,
        customerContactInfo: customerContactInfo,
        customerAddress: customerAddress,
        remarks: remarks,
      );

      if (success) {
        _successMessage = 'Serial verification successful';
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
    _successMessage = '';
    notifyListeners();
  }

  void _setSuccess(String message) {
    _successMessage = message;
    _errorMessage = '';
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = '';
    _successMessage = '';
  }
}