// lib/screen/scan/scan_screen.dart
import 'package:flutter/material.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/core/providers/scan_provider.dart';
import 'package:primax/screen/scan/veryfiyserial.dart';
import 'package:primax/services/connectivity_service.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_button.dart';


class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _barcodeController = TextEditingController();

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
                const SizedBox(height: 40),

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
                            onPressed: () => Navigator.pop(context),
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
                            const Icon(Icons.workspace_premium, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text('01',
                              // '${profileProvider.userProfile?.points ?? 0}',
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

                const SizedBox(height: 16),

                // Scan card
                _buildScanCard(),

                const SizedBox(height: 20),

                // Manual entry card
                _buildManualEntryCard(scanProvider, isConnected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanCard() {
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                size: 84,
                color: Colors.white,
              ),
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

            // Scan button
            GestureDetector(
              onTap: () {
                _launchBarcodeScannerCamera();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    "Scan Now",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

  Widget _buildManualEntryCard(ScanProvider scanProvider, bool isConnected) {
    return Card(
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Card image
            GestureDetector(
              onTap: () {
                if (isConnected) {
                  _showSampleBarcodeDialog();
                }
              },
              child: Image.asset(
                'assets/images/Untitled.png',
                height: 100,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              "Enter Product Barcode",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

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
            ),

            const SizedBox(height: 10),

            // Description
            const Text(
              "Use Camera to scan Privex card & add Loyalty points to your account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),

            const SizedBox(height: 16),

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
              onPressed: ()=>isConnected && _barcodeController.text.isNotEmpty
                  ? () => _submitBarcode(scanProvider)
                  : null,
            ),

            const SizedBox(height: 16),

            // Verify Serial link
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  VerifySerial(),
                  ),
                );
              },
              child: const Text(
                "Need to verify a serial number?",
                style: TextStyle(color: Colors.blue),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _launchBarcodeScannerCamera() {
    // In a real implementation, you'd use a barcode scanner package
    // such as flutter_barcode_scanner or mobile_scanner

    // For this example, we'll just show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Scanner'),
        content: const Text('This would launch the barcode scanner camera in a real implementation.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Simulate scanning a barcode
              _barcodeController.text = "SAMPLE123456";
            },
            child: const Text('Simulate Scan'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSampleBarcodeDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Success icon
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),

              const SizedBox(height: 16),

              // Title
              const Text(
                "Congratulations",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "You Have Earned",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 16),

              // Points earned
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00C853), // Green
                      Color(0xFF00B0FF), // Blue
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '100',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Points",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitBarcode(ScanProvider scanProvider) async {
    if (_barcodeController.text.isEmpty) {
      return;
    }

    final barcode = _barcodeController.text.trim();
    final success = await scanProvider.scanBarcode(barcode);

    if (success) {
      // Show success dialog
      _showSuccessDialog(scanProvider.lastPointsEarned);

      // Clear the input
      _barcodeController.clear();
    }
  }

  void _showSuccessDialog(int pointsEarned) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Success icon
              Image.asset(
                'assets/images/image116.png',
                height: 80,
                width: 80,
              ),

              const SizedBox(height: 16),

              // Title
              const Text(
                "Congratulations",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "You Have Earned",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 16),

              // Points earned
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00C853), // Green
                      Color(0xFF00B0FF), // Blue
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      '$pointsEarned',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Points",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}