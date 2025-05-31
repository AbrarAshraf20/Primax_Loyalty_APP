// lib/screen/lucky_draw_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:primax/core/providers/lucky_draw_provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/core/utils/app_config.dart';
import 'package:primax/models/lucky_draw.dart';
import 'package:provider/provider.dart';

import '../../widgets/network_status_indicator.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/payment_method_selection.dart';
import '../../widgets/delivery_info_form.dart';

class LuckyDrawDetailScreen extends StatefulWidget {
  const LuckyDrawDetailScreen({Key? key}) : super(key: key);

  @override
  _LuckyDrawDetailScreenState createState() => _LuckyDrawDetailScreenState();
}

class _LuckyDrawDetailScreenState extends State<LuckyDrawDetailScreen> {
  bool _isParticipating = false;

  @override
  Widget build(BuildContext context) {
    return NetworkStatusIndicator(
      child: Consumer<LuckyDrawProvider>(
        builder: (context, provider, child) {
          final draw = provider.selectedDraw;

          if (draw == null) {
            // If no draw is selected, go back to the list
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });
            return const SizedBox();
          }

          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/LuckyDraw.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back button
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

                          // Title
                          const Flexible(
                            child: Text(
                              'Lucky Draw Details',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Points
                          Consumer<ProfileProvider>(
                            builder: (context, profileProvider, _) {
                              return Container(
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
                                  mainAxisSize: MainAxisSize.min,
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
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Draw Details Card
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xffF4F4F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                            // Image
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              child: Image.network(
                                "${AppConfig.imageBaseUrl}${draw.thumbnail}",
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 200,
                                    width: double.infinity,
                                    color: Colors.grey[200],
                                    child: const Center(child: CircularProgressIndicator()),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Draw name
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                draw.name,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Draw details
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  _buildInfoRow('Status', draw.isActive ? 'Active' : 'Inactive',
                                      color: draw.isActive ? Colors.green : Colors.red),
                                  _buildInfoRow('Points Required', draw.minimumPoints.toString()),
                                  _buildInfoRow('Minimum Users', draw.minimumUsers.toString()),
                                  _buildInfoRow('Multiple Entries',
                                      draw.allowsMultipleParticipation ? 'Allowed' : 'Not Allowed'),
                                  if (draw.endTime != null)
                                    _buildInfoRow('End Date', _formatDate(draw.endTime!)),
                                  _buildInfoRow('Created At', _formatDate(draw.createdAt)),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Points indicator
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset('assets/icons/Group2.svg'),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${draw.minimumPoints}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),
                            const Text('Points Required'),

                            const SizedBox(height: 30),

                            // Participate Button
                            Consumer<ProfileProvider>(
                              builder: (context, profileProvider, _) {
                                final userPoints = profileProvider.userProfile?.tokens ?? 0;
                                final hasEnoughPoints = userPoints >= draw.minimumPoints;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  child: GestureDetector(
                                    onTap: hasEnoughPoints && !_isParticipating && draw.isActive
                                        ? () => _showParticipationDialog(context, draw, hasEnoughPoints)
                                        : null,
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: hasEnoughPoints && !_isParticipating && draw.isActive
                                            ? const LinearGradient(
                                          colors: [
                                            Color(0xFF00C853), // Green
                                            Color(0xFF00B0FF), // Blue
                                          ],
                                        )
                                            : LinearGradient(
                                          colors: [
                                            Colors.grey.shade400,
                                            Colors.grey.shade500,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _getButtonText(
                                            hasEnoughPoints: hasEnoughPoints,
                                            isActive: draw.isActive,
                                            isParticipating: _isParticipating,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: color ?? Colors.black,
              ),
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getButtonText({
    required bool hasEnoughPoints,
    required bool isActive,
    required bool isParticipating,
  }) {
    if (isParticipating) {
      return 'Processing...';
    }

    if (!isActive) {
      return 'Draw Inactive';
    }

    if (!hasEnoughPoints) {
      return 'Insufficient Points';
    }

    return 'Participate';
  }

  void _showParticipationDialog(BuildContext context, LuckyDraw draw, bool hasEnoughPoints) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        Map<String, String>? paymentInfo;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.95,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    // Title
                    const Text(
                      'Lucky Draw Participation',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      draw.cashornot == "1"
                          ? 'Please provide your payment information to participate in the lucky draw.'
                          : 'Please provide your delivery information to participate in the lucky draw.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Show different forms based on cashornot value
                    if (draw.cashornot == "1") ...[
                      // Cash prize - show payment method selection
                      PaymentMethodSelection(
                        onPaymentInfoChanged: (info) {
                          setState(() {
                            paymentInfo = info;
                          });
                        },
                        onTermsPressed: () {
                          _showTermsAndConditions();
                        },
                      ),
                    ] else ...[
                      // Non-cash prize - show delivery info form
                      DeliveryInfoForm(
                        onDeliveryInfoChanged: (info) {
                          setState(() {
                            paymentInfo = info;
                          });
                        },
                        onTermsPressed: () {
                          _showTermsAndConditions();
                        },
                      ),
                    ],

                    const SizedBox(height: 30),

                    // Participate button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: hasEnoughPoints && paymentInfo != null && !_isParticipating
                            ? () async {
                                // Store necessary data before closing the dialog
                                final currentDrawId = draw.id;
                                final currentCashOrNot = draw.cashornot;
                                final currentPaymentInfo = Map<String, String>.from(paymentInfo!);
                                
                                // Close the dialog first
                                Navigator.pop(context);
                                
                                // Then participate in the draw
                                await _participateInDraw(currentDrawId, currentPaymentInfo, currentCashOrNot);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C853),
                          disabledBackgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          _isParticipating ? 'Processing...' : 'Participate in Lucky Draw',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _participateInDraw(int drawId, Map<String, String> paymentInfo, String cashOrNot) async {
    // Check if widget is still mounted before using setState
    if (!mounted) return;
    
    setState(() {
      _isParticipating = true;
    });

    try {
      final luckyDrawProvider = Provider.of<LuckyDrawProvider>(context, listen: false);
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      
      final success = await luckyDrawProvider.enterLuckyDraw(drawId, paymentInfo, cashOrNot);

      // Check if widget is still mounted before updating state
      if (!mounted) return;
      
      setState(() {
        _isParticipating = false;
      });

      if (success) {
        // Refresh profile to update points
        await profileProvider.getProfileDetails();

        // Show success message using CustomSnackBar
        if (mounted) {
          CustomSnackBar.showSuccess(
            message: 'Successfully entered the lucky draw!',
          );
        }
      } else {
        // Show error message using CustomSnackBar
        if (mounted) {
          CustomSnackBar.showError(
            message: luckyDrawProvider.errorMessage.isNotEmpty
                ? luckyDrawProvider.errorMessage
                : 'Failed to enter the lucky draw',
          );
        }
      }
    } catch (e) {
      // Handle any errors
      if (mounted) {
        setState(() {
          _isParticipating = false;
        });
        
        CustomSnackBar.showError(
          message: 'An error occurred: ${e.toString()}',
        );
      }
    }
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'Terms and Conditions for Lucky Draw Participation\n\n'
            '1. Lucky draw participation is subject to availability and may be discontinued without notice.\n\n'
            '2. Payment information provided must be accurate and belong to the account holder.\n\n'
            '3. Draw results will be announced within the specified timeframe.\n\n'
            '4. The company reserves the right to verify payment information before processing winnings.\n\n'
            '5. Winnings cannot be exchanged for cash or transferred to another account.\n\n'
            '6. By participating in the lucky draw, you agree to these terms and conditions.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}