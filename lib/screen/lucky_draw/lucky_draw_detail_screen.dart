// lib/screen/lucky_draw_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:primax/core/providers/lucky_draw_provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/network_status_indicator.dart';

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
              child: Column(
                children: [
                  const SizedBox(height: 50),
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
                        const Text(
                          'Lucky Draw Details',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.67,
                        decoration: BoxDecoration(
                          color: const Color(0xffF4F4F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              child: Image.asset(
                                'assets/images/Frame62.png',
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Draw name
                            Text(
                              draw.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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
                              width: 85,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: GestureDetector(
                                    onTap: hasEnoughPoints && !_isParticipating && draw.isActive
                                        ? () => _participateInDraw(context, draw.id)
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
                ],
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
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color ?? Colors.black,
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

  Future<void> _participateInDraw(BuildContext context, int drawId) async {
    setState(() {
      _isParticipating = true;
    });

    final luckyDrawProvider = Provider.of<LuckyDrawProvider>(context, listen: false);

    final success = await luckyDrawProvider.enterLuckyDraw(drawId);

    setState(() {
      _isParticipating = false;
    });

    if (success) {
      // Refresh profile to update points
      await Provider.of<ProfileProvider>(context, listen: false).getProfileDetails();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully entered the lucky draw!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(luckyDrawProvider.errorMessage.isNotEmpty
              ? luckyDrawProvider.errorMessage
              : 'Failed to enter the lucky draw'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}