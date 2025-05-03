import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../create_account_screen/create_account_screen.dart';

class PlatformScreen extends StatelessWidget {
  const PlatformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60), // Spacing for status bar
          const Center(
            child: Text(
              "Select your Role",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),

          // Cards Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPlatformCard(
                  onTap: (){
                    CreateAccountScreen(role: 'Installer Sign up',).launch(context,pageRouteAnimation: PageRouteAnimation.Slide);

                  },
                  icon: 'assets/icons/Group12.svg',
                  title: "Installer",
                  subtitle: "Manage and Track Your Calculations ",
                  color: Color(0xffDDF6FF),
                  color1: Color(0xffB8EDFF),
                  iconColor: Colors.blue,
                ),
                const SizedBox(width: 16), // Spacing between cards
                _buildPlatformCard(
                   onTap:(){
                     CreateAccountScreen(role: 'Dealer Sign up',).launch(context,pageRouteAnimation: PageRouteAnimation.Slide);

                   },
                    icon: 'assets/icons/scan.svg',
                    title: "Dealer",
                    subtitle: "Manage and Track Your Documents & Reports ",
                    color: Color(0xffEDFCF2),color1: Color(0xffD3F8DF),
                    iconColor: Colors.green,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(right: 165.0),
            child: _buildPlatformCard(
              onTap:(){
                CreateAccountScreen(role: 'Distributor Sign up',).launch(context,pageRouteAnimation: PageRouteAnimation.Slide);

              },
              icon: 'assets/icons/scan1.svg',
              title: "Distributor",
              subtitle: "Manage and Track Your Documents & Reports  ",
              color: Color(0xffEDFCF2),color1: Color(0xffD3F8DF),
              iconColor: Colors.green,
            ),
          ),


          const Expanded(
            child: SizedBox(), // For spacing to match UI
          ),
          _buildGradientBackground(), // Gradient effect at the bottom
        ],
      ),
    );
  }

  // Widget to build the cards
  Widget _buildPlatformCard({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,color1,
    required Color iconColor, required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 160,
          width: 160,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color1,
                    borderRadius:BorderRadius.circular(5),
                    border: Border.all(color: iconColor)
                      
                  ),
                  child: SvgPicture.asset(icon, color: iconColor)),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey[700])),
            ],
          ),
        ),
      ),
    );
  }

  // Gradient Background at Bottom
  Widget _buildGradientBackground() {
    return Container(
      height: 150,
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