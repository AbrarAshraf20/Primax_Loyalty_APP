// lib/screen/donation_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:primax/core/utils/app_config.dart';
import 'package:primax/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:primax/core/providers/donation_provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/services/connectivity_service.dart';
import '../models/foundation.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_snackbar.dart';

class DonationScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  
  const DonationScreen({Key? key, this.onBackPressed}) : super(key: key);

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  @override
  void initState() {
    super.initState();
    // Coming Soon - Don't fetch foundations
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final donationProvider = Provider.of<DonationProvider>(context, listen: false);
    //   donationProvider.getFoundations();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/LuckyDraw.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header
              Row(
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
                        icon: Icon(CupertinoIcons.back,color: Colors.black,),
                        onPressed: widget.onBackPressed ?? () {},
                      ),
                    ),
                  ),
                  const Text(
                    'Donation',
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
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Coming Soon Content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF00C853),
                              Color(0xFF00B0FF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Icon(
                          Icons.volunteer_activism,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Title
                      const Text(
                        'Coming Soon!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'We\'re working on bringing you the ability to donate your points to worthy causes. Stay tuned!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Decorative elements
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00C853),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00B0FF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Coming Soon - Foundation card and detail screen methods are commented out for now
  // Widget _buildFoundationCard(BuildContext context, Foundation foundation) {...}
}

// Coming Soon - DonationDetailScreen is commented out for now
// class DonationDetailScreen extends StatefulWidget {...}