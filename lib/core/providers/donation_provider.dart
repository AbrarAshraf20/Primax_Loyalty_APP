// lib/core/providers/donation_provider.dart
import 'package:flutter/foundation.dart';
import 'package:primax/core/di/service_locator.dart';
import '../../models/foundation.dart';
import '../../services/donation_service.dart';
import '../network/api_exception.dart';
import 'profile_provider.dart';

class DonationProvider extends ChangeNotifier {
  final DonationService _donationService = locator<DonationService>();
  final ProfileProvider _profileProvider = locator<ProfileProvider>();

  // State variables
  bool _isLoading = false;
  bool _isDonating = false;
  String _errorMessage = '';
  String _successMessage = '';
  List<Foundation> _foundations = [];
  Foundation? _selectedFoundation;

  // Getters
  bool get isLoading => _isLoading;
  bool get isDonating => _isDonating;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  List<Foundation> get foundations => _foundations;
  Foundation? get selectedFoundation => _selectedFoundation;

  // Select a foundation
  void selectFoundation(Foundation foundation) {
    _selectedFoundation = foundation;
    notifyListeners();
  }

  // Get all foundations
  Future<void> getFoundations() async {
    _setLoading(true);
    _clearMessages();

    try {
      _foundations = await _donationService.getFoundations();
      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
    }
  }

  // Make a donation
  Future<bool> makeDonation({
    required int foundationId,
    required int amount,
    required String name,
    required String message,
  }) async {
    _setDonating(true);
    _clearMessages();

    try {
      final result = await _donationService.makeDonation(
        foundationId: foundationId,
        amount: amount,
        name: name,
        message: message,
      );

      if (result['success'] == true) {
        _successMessage = result['message'] ?? 'Donation successful';

        // Update profile points if available
        await _profileProvider.getProfileDetails();

        _setDonating(false);
        return true;
      } else {
        _setError(result['message'] ?? 'Donation failed');
        _setDonating(false);
        return false;
      }
    } catch (e) {
      _setError(e is ApiException ? e.message : 'An unexpected error occurred');
      _setDonating(false);
      return false;
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setDonating(bool donating) {
    _isDonating = donating;
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
    notifyListeners();
  }
}