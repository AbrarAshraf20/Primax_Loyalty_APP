// lib/providers/scan_provider.dart
import 'dart:io';

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

        // Update drawer provider with new points total if available
        if (result['totalPoints'] != null) {
          _profileProvider.updatePoints(result['totalPoints']);
        } else {
          // Refresh drawer to get updated points
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
  String _verificationMessage = '';
  String _verificationBarcode = '';
  
  // Additional getters for verification response
  String get verificationMessage => _verificationMessage;
  String get verificationBarcode => _verificationBarcode;
  
  Future<bool> verifySerial({
    required String serialNumber,  // Added scan number parameter
    required String name,
    required String mobile,
    required String item,
    required String city,
    required String customerName,
    required String customerContactInfo,
    required String customerAddress,
    required String remarks,
    required File image,
  }) async {
    _setLoading(true);
    _clearMessages();
    _verificationMessage = '';
    _verificationBarcode = '';

    try {
      final result = await _scanService.verifySerial(
        serialNumber: serialNumber,  // Pass the scan number
        name: name,
        mobile: mobile,
        item: item,
        city: city,
        customerName: customerName,
        customerContactInfo: customerContactInfo,
        customerAddress: customerAddress,
        remarks: remarks,
        image: image,
      );

      if (result['success'] == true) {
        _successMessage = result['message'] ?? 'Serial verification successful';
        _verificationMessage = result['message'] ?? 'Serial verification successful';
        _verificationBarcode = result['barcode'] ?? serialNumber;
        _setLoading(false);
        return true;
      } else {
        _setError(result['message'] ?? 'Verification failed');
        _setLoading(false);
        return false;
      }
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