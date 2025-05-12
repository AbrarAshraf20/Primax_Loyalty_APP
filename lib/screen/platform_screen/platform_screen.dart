import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:primax/routes/routes.dart';
import 'package:primax/screen/create_account_screen/create_account_screen.dart';

class PlatformScreen extends StatelessWidget {
  const PlatformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // Header
              const Center(
                child: Text(
                  "Select your Role",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),

              // First row - Installer and Dealer
              Row(
                children: [
                  // Installer Card
                  Expanded(
                    child: _buildPlatformCard(
                      context: context,
                      icon: 'assets/icons/Group12.svg',
                      title: "Installer",
                      subtitle: "Manage and Track Your Calculations",
                      color: Color(0xffDDF6FF),
                      color1: Color(0xffB8EDFF),
                      iconColor: Colors.blue,
                      role: 'Installer Sign up',
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Dealer Card
                  Expanded(
                    child: _buildPlatformCard(
                      context: context,
                      icon: 'assets/icons/scan.svg',
                      title: "Dealer",
                      subtitle: "Manage and Track Your Documents & Reports",
                      color: Color(0xffEDFCF2),
                      color1: Color(0xffD3F8DF),
                      iconColor: Colors.green,
                      role: 'Dealer Sign up',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Second row - Distributor
              SizedBox(
                width: screenWidth / 2 - 12, // Half screen minus some padding
                child: _buildPlatformCard(
                  context: context,
                  icon: 'assets/icons/scan1.svg',
                  title: "Distributor",
                  subtitle: "Manage and Track Your Documents & Reports",
                  color: Color(0xffEDFCF2),
                  color1: Color(0xffD3F8DF),
                  iconColor: Colors.green,
                  role: 'Distributor Sign up',
                ),
              ),

              // Spacer
              const Expanded(child: SizedBox()),

              // Gradient Background at Bottom
              _buildGradientBackground(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build the role selection cards
  Widget _buildPlatformCard({
    required BuildContext context,
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color color1,
    required Color iconColor,
    required String role,
  }) {
    return InkWell(
      onTap: () {
        // Navigate to CreateAccountScreen with the selected role
        Navigator.pushNamed(
          context,
          Routes.register,
          arguments: {'role': role},
        );
        // CreateAccountScreen(role: role,).launch(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: iconColor),
              ),
              child: SvgPicture.asset(icon, color: iconColor),
            ),

            const SizedBox(height: 8),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Gradient Background at Bottom
  Widget _buildGradientBackground() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFE0F7FA)], // Light blue gradient
        ),
      ),
    );
  }
}