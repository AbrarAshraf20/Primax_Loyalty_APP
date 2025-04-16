// lib/widgets/network_status_indicator.dart
import 'package:flutter/material.dart';
import 'package:primax/core/providers/network_status_provider.dart';
import 'package:provider/provider.dart';

class NetworkStatusIndicator extends StatelessWidget {
  final Widget child;
  final Widget? offlineWidget;

  const NetworkStatusIndicator({
    Key? key,
    required this.child,
    this.offlineWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkStatusProvider>(
      builder: (context, networkStatus, _) {
        if (networkStatus.isConnected) {
          return child;
        } else {
          return offlineWidget ?? _buildDefaultOfflineWidget(context);
        }
      },
    );
  }

  Widget _buildDefaultOfflineWidget(BuildContext context) {
    return Container(
      color: Colors.red.shade50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'No internet connection',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your connection and try again',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Manually check connectivity
              Provider.of<NetworkStatusProvider>(context, listen: false)
                  .checkConnectivity();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}