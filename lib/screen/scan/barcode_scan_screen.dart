// lib/screen/scan/barcode_scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool _permissionDenied = false;
  bool _torchOn = false;
  bool _frontCamera = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _permissionDenied = status != PermissionStatus.granted;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scanner'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Camera permission is required to scan barcodes',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _checkPermission();
                },
                child: const Text('Grant Permission'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        backgroundColor: const Color(0xFF00C853),
        actions: [
          IconButton(
            icon: Icon(_torchOn ? Icons.flash_off : Icons.flash_on),
            onPressed: () {
              setState(() {
                _torchOn = !_torchOn;
                controller.toggleTorch();
              });
            },
          ),
          IconButton(
            icon: Icon(_frontCamera ? Icons.camera_rear : Icons.camera_front),
            onPressed: () {
              setState(() {
                _frontCamera = !_frontCamera;
                controller.switchCamera();
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;

              // Only process the first detected barcode to avoid multiple callbacks
              if (barcodes.isNotEmpty) {
                final barcode = barcodes.first;
                if (barcode.rawValue != null) {
                  final String code = barcode.rawValue!;
                  debugPrint('Barcode found! $code');
                  // Return the scanned barcode to calling screen
                  Navigator.pop(context, code);
                }
              }
            },
          ),
          // Scanner overlay
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                final scanAreaSize = size.width * 0.7;
                final scanAreaTop = (size.height - scanAreaSize) / 2;
                final scanAreaLeft = (size.width - scanAreaSize) / 2;

                return Stack(
                  children: [
                    // Cut out the scan area
                    Positioned(
                      top: scanAreaTop,
                      left: scanAreaLeft,
                      width: scanAreaSize,
                      height: scanAreaSize,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const SizedBox(),
                      ),
                    ),
                    // Instructions
                    Positioned(
                      bottom: scanAreaTop - 60,
                      left: 0,
                      right: 0,
                      child: const Center(
                        child: Text(
                          'Position the barcode within the square',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Cancel button
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
                label: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black54,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}