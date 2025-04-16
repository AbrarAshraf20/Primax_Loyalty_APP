// lib/core/providers/network_status_provider.dart
import 'package:flutter/material.dart';
import 'package:primax/services/connectivity_service.dart';

class NetworkStatusProvider extends ChangeNotifier {
  final ConnectivityService _connectivityService;

  NetworkStatusProvider(this._connectivityService) {
    // Listen for connectivity changes
    _connectivityService.connectionStatusStream.listen((isConnected) {
      if (_isConnected != isConnected) {
        _isConnected = isConnected;
        notifyListeners();
      }
    });

    // Initialize with current value
    _isConnected = _connectivityService.isConnected;
  }

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  // Method to manually check connection status
  Future<void> checkConnectivity() async {
    final isConnected = await _connectivityService.checkConnectivity();
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      notifyListeners();
    }
  }
}