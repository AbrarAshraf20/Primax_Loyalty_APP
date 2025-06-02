// lib/screen/scan/barcode_scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> with WidgetsBindingObserver {
  late final MobileScannerController controller;
  bool _permissionDenied = false;
  bool _torchOn = false;
  bool _frontCamera = false;
  bool _isInitialized = false;
  bool _isLoading = true;
  bool _hasCameraError = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize controller with safe error handling
    try {
      controller = MobileScannerController(
        autoStart: false, // Start manually after permission check
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        torchEnabled: false,
        formats: const [BarcodeFormat.all], // Support all formats
      );

      // Delayed initialization to allow UI to build first
      Future.microtask(() async {
        try {
          await _checkPermission();
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        } catch (e) {
          debugPrint('Error during permission check: $e');
          if (mounted) {
            setState(() {
              _permissionDenied = true;
              _isInitialized = true;
              _isLoading = false;
            });
          }
        }
      });
    } catch (e) {
      debugPrint('Error initializing camera controller: $e');
      // Handle initialization error
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _hasCameraError = true;
            _errorMessage = 'Failed to initialize camera: $e';
            _isInitialized = true;
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes with error protection
    if (!mounted) return;

    try {
      if (state == AppLifecycleState.resumed) {
        // Only resume if we have permission and are initialized
        if (!_permissionDenied && _isInitialized) {
          controller.start().catchError((e) {
            debugPrint('Error starting camera on resume: $e');
          });
        }
      } else if (state == AppLifecycleState.inactive ||
                state == AppLifecycleState.paused) {
        // Always try to stop when going to background
        controller.stop().catchError((e) {
          debugPrint('Error stopping camera: $e');
        });
      }
    } catch (e) {
      debugPrint('Error in lifecycle state change: $e');
    }
  }

  @override
  void dispose() {
    // Clean up safely
    WidgetsBinding.instance.removeObserver(this);

    try {
      controller.stop().catchError((e) {
        debugPrint('Error stopping camera on dispose: $e');
      });
      controller.dispose();
    } catch (e) {
      debugPrint('Error disposing camera controller: $e');
    }

    super.dispose();
  }

  Future<void> _checkPermission() async {
    try {
      // Request permission directly without checking status first
      final status = await Permission.camera.request();
      if (mounted) {
        setState(() {
          _permissionDenied = status != PermissionStatus.granted;
          _isInitialized = true;
        });
      }

      if (status == PermissionStatus.granted) {
        // Start camera with error handling
        try {
          await controller.start().timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              debugPrint('Camera start timed out - continuing anyway');
              return;
            },
          );
        } catch (e) {
          debugPrint('Error starting camera: $e');
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error in permission check: $e');
      if (mounted) {
        setState(() {
          _permissionDenied = true;
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show permission denied or camera error screen
    if ((_permissionDenied && _isInitialized) || _hasCameraError) {
      return WillPopScope(
        // Make sure we can safely pop even if there's a navigation error
        onWillPop: () async {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Scanner'),
            backgroundColor: const Color(0xFF00C853),
            elevation: 0,
            // Add safe back button
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    _hasCameraError
                        ? 'Camera could not be initialized'
                        : 'Camera permission is required to scan barcodes',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    _hasCameraError
                        ? 'Please try again or check your device settings'
                        : 'Please allow camera access to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(height: 30),
                // Action button based on error type
                if (_hasCameraError)
                  ElevatedButton.icon(
                    onPressed: () async {
                      // For camera errors, restart the controller
                      if (mounted) {
                        setState(() {
                          _hasCameraError = false;
                          _isLoading = true;
                        });
                        try {
                          controller = MobileScannerController(
                            autoStart: false,
                            detectionSpeed: DetectionSpeed.normal,
                            facing: CameraFacing.back,
                            torchEnabled: false,
                          );
                          await _checkPermission();
                        } catch (e) {
                          debugPrint('Failed to reinitialize camera: $e');
                          if (mounted) {
                            setState(() {
                              _hasCameraError = true;
                              _isLoading = false;
                            });
                          }
                        }
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  )
                else if (_permissionDenied)
                  Column(
                    children: [
                      // Primary button to go to settings after permission was denied
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await openAppSettings();
                          } catch (e) {
                            debugPrint('Error opening app settings: $e');
                          }
                        },
                        icon: const Icon(Icons.settings),
                        label: const Text('Open Settings'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C853),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Cancel button for when permission is denied
                      OutlinedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF00C853)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        // Safe navigation
        try {
          // Clean up camera before popping
          await controller.stop().catchError((e) {
            debugPrint('Error stopping camera on pop: $e');
          });
          return true;
        } catch (e) {
          debugPrint('Error in WillPopScope: $e');
          return true;
        }
      },
      child: Hero(
        tag: 'scanner_screen', // Hero tag for smooth transition
        child: Scaffold(
        appBar: AppBar(
          title: const Text('Scan Barcode'),
          backgroundColor: const Color(0xFF00C853),
          elevation: 0,
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
            // Loading indicator
            if (_isLoading)
              Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF00C853),
                  ),
                ),
              ),

            // Camera scanner with error handling
            Opacity(
              opacity: _isLoading ? 0 : 1,
              child: MobileScanner(
                controller: controller,
                onDetect: (capture) {
                  try {
                    final List<Barcode> barcodes = capture.barcodes;

                    // Only process the first detected barcode to avoid multiple callbacks
                    if (barcodes.isNotEmpty) {
                      final barcode = barcodes.first;
                      if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
                        final String code = barcode.rawValue!;
                        debugPrint('Barcode found! $code');

                        // Return the scanned barcode to calling screen - with pop protection
                        if (mounted && Navigator.canPop(context)) {
                          Navigator.pop(context, code);
                        }
                      }
                    }
                  } catch (e) {
                    debugPrint('Error processing barcode: $e');
                  }
                },
                errorBuilder: (context, error) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 64,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Camera error: ${error.toString()}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Go Back'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          // Scanner overlay - only show if not loading
          if (!_isLoading)
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
                      // Cut out the scan area with animated border
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
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      // Scanner corner highlights
                      Positioned(
                        top: scanAreaTop,
                        left: scanAreaLeft,
                        child: _buildCornerHighlight(20, 2, topLeft: true),
                      ),
                      Positioned(
                        top: scanAreaTop,
                        right: scanAreaLeft,
                        child: _buildCornerHighlight(20, 2, topRight: true),
                      ),
                      Positioned(
                        bottom: scanAreaTop,
                        left: scanAreaLeft,
                        child: _buildCornerHighlight(20, 2, bottomLeft: true),
                      ),
                      Positioned(
                        bottom: scanAreaTop,
                        right: scanAreaLeft,
                        child: _buildCornerHighlight(20, 2, bottomRight: true),
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
          // Cancel button - only show if not loading
          if (!_isLoading)
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
      ),
    ));
  }

  // Helper to build corner highlights for the scan area
  Widget _buildCornerHighlight(double length, double thickness, {
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return SizedBox(
      width: length,
      height: length,
      child: CustomPaint(
        painter: CornerPainter(
          color: const Color(0xFF00C853),
          thickness: thickness,
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }
}

// Custom painter for scanner corners
class CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  CornerPainter({
    required this.color,
    required this.thickness,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    if (topLeft) {
      canvas.drawPath(
        Path()
          ..moveTo(0, size.height * 0.3)
          ..lineTo(0, 0)
          ..lineTo(size.width * 0.3, 0),
        paint,
      );
    }

    if (topRight) {
      canvas.drawPath(
        Path()
          ..moveTo(size.width * 0.7, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height * 0.3),
        paint,
      );
    }

    if (bottomLeft) {
      canvas.drawPath(
        Path()
          ..moveTo(0, size.height * 0.7)
          ..lineTo(0, size.height)
          ..lineTo(size.width * 0.3, size.height),
        paint,
      );
    }

    if (bottomRight) {
      canvas.drawPath(
        Path()
          ..moveTo(size.width * 0.7, size.height)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width, size.height * 0.7),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
