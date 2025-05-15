// lib/screen/scan/scan_screen.dart
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/core/providers/scan_provider.dart';
import 'package:primax/screen/scan/veryfiyserial.dart';
import 'package:primax/services/connectivity_service.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_button.dart';
import 'barcode_scan_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _barcodeController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get providers
    final scanProvider = Provider.of<ScanProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final isConnected = Provider.of<ConnectivityService>(context).isConnected;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/LuckyDraw.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // App bar section
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(20),
                        elevation: 2,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 16),
                            onPressed: () {
                              // Don't try to pop, just go back to home in parent Navigator
                              // by not doing anything - the WillPopScope in dashboard will handle it
                            },
                          ),
                        ),
                      ),
                      const Text(
                        'Scan for Rewards',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF00C853), // Green
                              Color(0xFF00B0FF), // Blue
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/icons/Group2.svg'),
                            const SizedBox(width: 4),
                            Text(
                              '${profileProvider.userProfile?.tokens ?? 0}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Scan card
                _buildScanCard(context, isConnected),

                const SizedBox(height: 20),

                // Manual entry card
                _buildManualEntryCard(context, scanProvider, isConnected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanCard(BuildContext context, bool isConnected) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF00B0FF), // Blue
            Color(0xFF00C853), // Green
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Camera icon
            SvgPicture.asset(
              'assets/icons/xmlid.svg',
              height: 120,
              color: Colors.white,
            ),

            const SizedBox(height: 30),

            // Title
            const Text(
              "Scan Product Barcode",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Description
            const Text(
              "Use Camera to scan Privex card & add Loyalty points to your account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),

            const SizedBox(height: 25),

            // Scan button with Hero animation for smooth transition
            Hero(
              tag: 'scanner_screen', // Same tag used in the scanner screen
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: isConnected ? () => _launchBarcodeScannerCamera(context) : null,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isConnected ? Colors.white : Colors.grey[300],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            color: isConnected ? Colors.black : Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isConnected ? "Scan Now" : "No Internet Connection",
                            style: TextStyle(
                              color: isConnected ? Colors.black : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildManualEntryCard(BuildContext context, ScanProvider scanProvider, bool isConnected) {
    return Card(
      color: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),

            // Card image
            GestureDetector(
              onTap: () {
                // Optional: Show sample barcode image
              },
              child: Image.asset(
                'assets/images/Untitled.png',
                scale: 5,
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              "Enter Product Barcode",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            // Barcode input
            TextField(
              controller: _barcodeController,
              decoration: InputDecoration(
                hintText: "Insert Card Number",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.text,
              enabled: !_isProcessing,
            ),

            const SizedBox(height: 10),

            // Description
            const Text(
              "Use Camera to scan Primax card & add Loyalty points to your account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),

            const SizedBox(height: 20),

            // Error message
            if (scanProvider.errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  scanProvider.errorMessage,
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ),

            // Success message
            if (scanProvider.successMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  scanProvider.successMessage,
                  style: TextStyle(color: Colors.green.shade800),
                ),
              ),

            // Submit button
            CustomButton(
              width: double.infinity,
              text: scanProvider.isLoading ? "Processing..." : "Submit",
              isLoading: scanProvider.isLoading,
              onPressed: ()=>isConnected && _barcodeController.text.isNotEmpty && !_isProcessing
                  ?_submitBarcode(context, scanProvider)
                  : null,
            ),

            const SizedBox(height: 20),

            // Verify Serial link
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) =>  VerifySerial(scanNumber: _barcodeController.text,),
            //       ),
            //     );
            //   },
            //   child: const Text(
            //     "Need to verify a serial number?",
            //     style: TextStyle(color: Colors.blue),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchBarcodeScannerCamera(BuildContext context) async {
    // Show loading indicator while initializing scanner
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFF00C853)),
                  SizedBox(height: 15),
                  Text("Opening camera...", style: TextStyle(color: Colors.black87))
                ],
              ),
            ),
          ),
        );
      }
    );

    try {
      // Use a custom page route for smoother transition
      final barcode = await Navigator.push<String>(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => const BarcodeScannerScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;

            var fadeAnimation = Tween(begin: begin, end: end).animate(
              CurvedAnimation(parent: animation, curve: curve),
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        ),
      );

      // Close loading dialog if it's still showing
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      if (barcode != null && barcode.isNotEmpty) {
        _barcodeController.text = barcode;

        // Automatically submit the barcode
        final scanProvider = Provider.of<ScanProvider>(context, listen: false);
        _submitBarcode(context, scanProvider);
      }
    } catch (e) {
      // Close loading dialog if error occurs
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      debugPrint('Error launching scanner: $e');

      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Camera Error'),
            content: Text('Could not open camera. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _submitBarcode(BuildContext context, ScanProvider scanProvider) async {
    if (_barcodeController.text.isEmpty || _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    final barcode = _barcodeController.text.trim();
    final success = await scanProvider.scanBarcode(barcode);

    setState(() {
      _isProcessing = false;
    });

    if (success) {
      // Get the user profile
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final userRole = profileProvider.userProfile?.role?.toLowerCase() ?? '';

      if (userRole == 'installer') {
        // If user is an installer, navigate to verify serial screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifySerial(scanNumber: barcode),
          ),
        );
      } else {
        // For other users, show success dialog
        _showSuccessDialog(context,scanProvider.lastPointsEarned,scanProvider.successMessage);
      }

      // Clear the input
      _barcodeController.clear();
    }
  }

  void _showSuccessDialog(BuildContext context,int pointsEarned, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/image120.png',
                      width: 40,
                      height: 40,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                IconButton(
                  icon: Image.asset('assets/images/image116.png'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),

                // Title
                const Text(
                  "Congratulations",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                 Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  "You Have Earned",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 5.0),
                  child: Container(
                    width: 90,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF00C853), // Green
                          Color(0xFF00B0FF), // Blue
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/Group2.svg'),
                        const SizedBox(width: 4),
                        Text(
                          '$pointsEarned',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Points",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }
}