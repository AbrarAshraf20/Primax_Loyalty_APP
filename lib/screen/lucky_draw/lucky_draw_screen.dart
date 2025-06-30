// lib/screen/lucky_draw_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:primax/core/providers/lucky_draw_provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/core/utils/app_config.dart';
import 'package:primax/models/lucky_draw.dart';
import 'package:primax/routes/routes.dart';
import 'package:provider/provider.dart';
import '../../widgets/network_status_indicator.dart';

class LuckyDrawScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  
  const LuckyDrawScreen({Key? key, this.onBackPressed}) : super(key: key);

  @override
  _LuckyDrawScreenState createState() => _LuckyDrawScreenState();
}

class _LuckyDrawScreenState extends State<LuckyDrawScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LuckyDrawProvider>(context, listen: false).fetchLuckyDraws();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use network status indicator to handle offline state
    return NetworkStatusIndicator(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/LuckyDraw.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<LuckyDrawProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${provider.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    provider.fetchLuckyDraws();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (provider.luckyDraws.isEmpty) {
          return const Center(
            child: Text('No lucky draws available at the moment.'),
          );
        }

        // Display lucky draws
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // App Bar section
              const SizedBox(height: 20),
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
                        icon: const Icon(Icons.arrow_back_ios, size: 16),
                        onPressed: widget.onBackPressed ?? () {},
                      ),
                    ),
                  ),
                  const Text(
                    'Lucky Draw',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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
              const SizedBox(height: 20),

              // Rules button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showLuckyDrawRules(context),
                      icon: const Icon(Icons.info_outline, size: 18),
                      label: const Text('Lucky Draw Rules'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Lucky draw list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => provider.fetchLuckyDraws(),
                  child: ListView.builder(
                    itemCount: provider.luckyDraws.length,
                    itemBuilder: (context, index) {
                      final draw = provider.luckyDraws[index];
                      return _buildLuckyDrawCard(context, draw);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLuckyDrawCard(BuildContext context, LuckyDraw draw) {
    return GestureDetector(
      onTap: () {
        Provider.of<LuckyDrawProvider>(context, listen: false).selectDraw(draw);
        Navigator.pushNamed(context, Routes.luckyDrawDetails);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: const Color(0xffF4F4F6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section - Using a placeholder since the API doesn't provide an image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
  "${AppConfig.imageBaseUrl}${draw.thumbnail}", // Default image
                fit: BoxFit.cover,
                height: 180,
                width: double.infinity,
              ),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          draw.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Points Required: ${draw.minimumPoints}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          'Minimum Users: ${draw.minimumUsers}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          'Status: ${draw.isActive ? 'Active' : 'Inactive'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: draw.isActive ? Colors.green : Colors.red,
                          ),
                        ),
                        if (draw.endTime != null)
                          Text(
                            'Ends on: ${_formatDate(draw.endTime!)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        Text(
                          'Multiple entries: ${draw.allowsMultipleParticipation ? 'Allowed' : 'Not allowed'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action buttons
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: const Color(0xffE9E9E9),
                        child: SvgPicture.asset('assets/icons/Vector.svg'),
                      ),
                      const SizedBox(height: 8),
                     if(draw.status=='off') TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routes.luckyDrawWinner,
                            arguments: {'drawId': draw.id},
                          );
                        },
                        child: const Text(
                          'Here is the\nWinners',
                          style: TextStyle(fontSize: 9, color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showWinnerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Winner'),
        content: const Text('The winner is John Doe!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLuckyDrawRules(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lucky Draw Rules & Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'LUCKY DRAW RULES & CONDITIONS\n\n'
            
            '1. Minimum User Participation:\n'
            'A lucky draw will only be activated once a minimum of users have successfully joined that particular draw campaign.\n\n'
            
            '2. Minimum Points Requirement:\n'
            'To be eligible for entry, users must have at least 20,000 points collected through the platform\'s activities.\n\n'
            
            '3. Activation Timeline Post User Milestone:\n'
            'Once the required number of users is reached, the lucky draw will be conducted exactly 2 months after that milestone.\n\n'
            
            '4. Multiple Entries:\n'
            'Users may be allowed to enter a draw more than once, depending on admin approval. Admin has full rights to decide whether multiple entries are permitted or not for a specific draw.\n\n'
            
            '5. Ongoing Participation Until Draw Date:\n'
            'Even after the user threshold is reached, new users can still participate and qualify until the actual draw date.\n\n'
            
            '6. Disqualification for Misuse:\n'
            'Users found using fake accounts, bots, or other dishonest methods will be permanently disqualified from all current and future lucky draws.\n\n'
            
            '7. Winner Announcement:\n'
            'Winners will be officially announced on the platform app within 24 hours after the draw takes place.\n\n'
            
            '8. Winner Verification Process:\n'
            'All selected winners must complete an identity verification process. Failure to do so will result in disqualification and a new winner will be selected.\n\n'
            
            '9. Right to Modify or Cancel:\n'
            'The organizers reserve the right to modify or cancel any rule, date, or draw without prior notice in case of unforeseen situations.\n\n'
            
            'APPLE DISCLAIMER:\n'
            'Apple Inc. is not a sponsor of, and is not involved in any way with, this contest or sweepstakes. Apple Inc. is not responsible for the operation of this contest or sweepstakes or the selection of winners.\n\n'
            
            'By participating in the lucky draw, you agree to these terms and conditions.',
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