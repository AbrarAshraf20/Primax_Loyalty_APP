import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:primax/routes/routes.dart';
import 'package:primax/screen/create_account_screen/create_account_screen.dart';

class PlatformScreen extends StatefulWidget {
  const PlatformScreen({super.key});

  @override
  State<PlatformScreen> createState() => _PlatformScreenState();
}

class _PlatformScreenState extends State<PlatformScreen> {
  // Track which card is selected
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions for responsive sizing
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 350;

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

              // Cards section
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Determine if we need to use a single column layout on very small screens
                    final useSingleColumn = constraints.maxWidth < 280;
                    
                    if (useSingleColumn) {
                      return _buildSingleColumnLayout();
                    } else {
                      return _buildRegularLayout(isSmallScreen);
                    }
                  }
                ),
              ),

              // Gradient Background at Bottom
              _buildGradientBackground(),
              
              // Proceed button
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedRole != null
                        ? () {
                            Navigator.pushNamed(
                              context,
                              Routes.register,
                              arguments: {'role': selectedRole},
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: const Text('Proceed', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Single column layout for very small screens
  Widget _buildSingleColumnLayout() {
    return ListView(
      shrinkWrap: true,
      children: [
        _buildPlatformCard(
          icon: 'assets/icons/installer.svg',
          title: "Installer",
          subtitle: "Manage and Track Your Calculations",
          baseColor: Color(0xffDDF6FF),
          accentColor: Color(0xffB8EDFF),
          iconColor: Colors.blue,
          role: 'Installer Sign up',
        ),
        const SizedBox(height: 16),
        _buildPlatformCard(
          icon: 'assets/icons/dealer.svg',
          title: "Dealer",
          subtitle: "Manage and Track Your Documents & Reports",
          baseColor: Color(0xffEDFCF2),
          accentColor: Color(0xffD3F8DF),
          iconColor: Colors.green,
          role: 'Dealer Sign up',
        ),
        const SizedBox(height: 16),
        _buildPlatformCard(
          icon: 'assets/icons/distributer.svg',
          title: "Distributor",
          subtitle: "Manage and Track Your Documents & Reports",
          baseColor: Color(0xffFFF2E2),
          accentColor: Color(0xffFFE0B2),
          iconColor: Colors.orange,
          role: 'Distributor Sign up',
        ),
      ],
    );
  }

  // Regular layout with a row of two cards on top and one at the bottom
  Widget _buildRegularLayout(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First row - Installer and Dealer
        Row(
          children: [
            // Installer Card
            Expanded(
              child: _buildPlatformCard(
                icon: 'assets/icons/installer.svg',
                title: "Installer",
                subtitle: "Manage and Track Your Calculations",
                baseColor: Color(0xffDDF6FF),
                accentColor: Color(0xffB8EDFF),
                iconColor: Colors.blue,
                role: 'Installer Sign up',
              ),
            ),
            const SizedBox(width: 16),

            // Dealer Card
            Expanded(
              child: _buildPlatformCard(
                icon: 'assets/icons/dealer.svg',
                title: "Dealer",
                subtitle: "Manage and Track Your Documents & Reports",
                baseColor: Color(0xffEDFCF2),
                accentColor: Color(0xffD3F8DF),
                iconColor: Colors.green,
                role: 'Dealer Sign up',
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Second row - Distributor
        SizedBox(
          width: isSmallScreen ? double.infinity : 180,
          child: _buildPlatformCard(
            icon: 'assets/icons/distributer.svg',
            title: "Distributor",
            subtitle: "Manage and Track Your Documents & Reports",
            baseColor: Color(0xffFFF2E2),
            accentColor: Color(0xffFFE0B2),
            iconColor: Colors.orange,
            role: 'Distributor Sign up',
          ),
        ),
        
        const Spacer(),
      ],
    );
  }

  // Widget to build the role selection cards
  Widget _buildPlatformCard({
    required String icon,
    required String title,
    required String subtitle,
    required Color baseColor,
    required Color accentColor,
    required Color iconColor,
    required String role,
  }) {
    final isSelected = selectedRole == role;
    
    // Adjust colors based on selection state
    final cardColor = isSelected ? accentColor : baseColor;
    final borderColor = isSelected ? iconColor : Colors.transparent;
    
    return GestureDetector(
      onTap: () {
        // Update the selected role and rebuild the UI
        setState(() {
          selectedRole = role;
        });
        
        // Add haptic feedback for better UX
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: iconColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: iconColor),
              ),
              child: SvgPicture.asset(icon, color: iconColor, height: 24),
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black87 : Colors.black54,
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.black87 : Colors.grey[700],
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
      height: 80,
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