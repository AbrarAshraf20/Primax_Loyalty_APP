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
import 'package:url_launcher/url_launcher.dart';

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
    // Fetch foundations when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final donationProvider = Provider.of<DonationProvider>(context, listen: false);
      donationProvider.getFoundations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);
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

              // Error message
              if (donationProvider.errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    donationProvider.errorMessage,
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),

              // Loading indicator
              if (donationProvider.isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              // No foundations found
              else if (donationProvider.foundations.isEmpty && !donationProvider.isLoading)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No foundations found',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: isConnected ? () => donationProvider.getFoundations() : null,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              // Foundations list
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => donationProvider.getFoundations(),
                    child: ListView.builder(
                      itemCount: donationProvider.foundations.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildFoundationCard(
                            context,
                            donationProvider.foundations[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoundationCard(BuildContext context, Foundation foundation) {
    String imageUrl = foundation.image;
    // Check if the image URL is a relative path and prepend the API base URL if needed
    if (imageUrl.startsWith('images/')) {
      // Assuming your API base URL is configured in ApiClient
      imageUrl = '${AppConfig.imageBaseUrl}${foundation.image}';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DonationDetailScreen(foundation: foundation),
          ),
        );
      },
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffF4F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to asset image if network image fails
                    return Image.asset(
                      'assets/images/Frame4.png',
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foundation.foundationName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            foundation.foundationDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[700], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: const Color(0xffE9E9E9),
                      child: SvgPicture.asset('assets/icons/Vector.svg'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DonationDetailScreen extends StatefulWidget {
  final Foundation foundation;

  const DonationDetailScreen({Key? key, required this.foundation}) : super(key: key);

  @override
  State<DonationDetailScreen> createState() => _DonationDetailScreenState();
}

class _DonationDetailScreenState extends State<DonationDetailScreen> {
  final int requiredPoints = 30; // Points required for donation

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    String imageUrl = widget.foundation.image;
    // Check if the image URL is a relative path and prepend the API base URL if needed
    if (imageUrl.startsWith('images/')) {
      // Assuming your API base URL is configured in ApiClient
      imageUrl = '${AppConfig.imageBaseUrl}${widget.foundation.image}';
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
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        icon: Icon(CupertinoIcons.back,color: Colors.black,),
                        onPressed: () => Navigator.pop(context),
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
                  ),
                ],
              ),
            ),
            // Foundation details
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
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          height: 220,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback to asset image if network image fails
                            return Image.asset(
                              'assets/images/Frame2.png',
                              fit: BoxFit.cover,
                              height: 220,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.foundation.foundationName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.foundation.foundationDescription,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Colors.grey[900]),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.green,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.watch_later_outlined),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  'Added on ${_formatDate(widget.foundation.createdAt)}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade600,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Charity Information',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Visit the official website to make secure donations',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Donate button - Redirect to external website
                      GestureDetector(
                        onTap: () {
                          _showExternalDonationDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF00C853), // Green
                                  Color(0xFF00B0FF), // Blue
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Text(
                                'Visit Charity Website',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
            ),
          ],
        ),
      ),
    );
  }

  // Format date string
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString.split('T')[0]; // Fallback format
    }
  }

  // Show external donation dialog - Apple compliant
  void _showExternalDonationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00C853), Color(0xFF00B0FF)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.volunteer_activism,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Title
                const Text(
                  "Support This Charity",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Description
                Text(
                  "To make a donation to ${widget.foundation.foundationName}, you'll be redirected to their official website where you can donate securely.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Apple Compliance Notice
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: const Text(
                    "💡 This app does not process donations directly. All donations are handled by the charity's official website.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _launchCharityWebsite(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C853),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Visit Website',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Launch charity website - Apple compliant external donation
  Future<void> _launchCharityWebsite() async {
    // Use the foundationLink from the foundation model
    final String websiteUrl = widget.foundation.foundationLink.isNotEmpty 
        ? widget.foundation.foundationLink 
        : 'https://example-charity.org';
    
    try {
      final Uri url = Uri.parse(websiteUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication, // Opens in external browser
        );
        Navigator.pop(context); // Close the dialog after opening browser
      } else {
        CustomSnackBar.showError(
          message: 'Unable to open charity website',
        );
      }
    } catch (e) {
      CustomSnackBar.showError(
        message: 'Error opening website: ${e.toString()}',
      );
    }
  }
}