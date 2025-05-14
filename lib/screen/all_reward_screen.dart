// lib/screen/all_rewards_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/core/providers/rewards_provider.dart';
import 'package:primax/core/utils/app_config.dart';
import 'package:primax/models/reward_model.dart';
import 'package:provider/provider.dart';

// Enum to define reward types
enum RewardType {
  club,
  featured,
}

class AllRewardsScreen extends StatefulWidget {
  final String title;
  final RewardType rewardType;

  const AllRewardsScreen({
    Key? key,
    required this.title,
    required this.rewardType,
  }) : super(key: key);

  @override
  _AllRewardsScreenState createState() => _AllRewardsScreenState();
}

class _AllRewardsScreenState extends State<AllRewardsScreen> {
  @override
  void initState() {
    super.initState();

    // Make sure rewards are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRewards();
    });
  }

  Future<void> _loadRewards() async {
    final rewardsProvider = Provider.of<RewardsProvider>(context, listen: false);

    // Check if we need to load data
    if ((widget.rewardType == RewardType.club && rewardsProvider.clubRewards.isEmpty) ||
        (widget.rewardType == RewardType.featured && rewardsProvider.featuredRewards.isEmpty)) {
      await rewardsProvider.loadAllRewardsData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        elevation: 0,
        leading:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        // iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        actions: [
          _buildPointsDisplay(),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/LuckyDraw.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: _buildRewardsList(),
      ),
    );
  }

  Widget _buildPointsDisplay() {
    return Consumer<ProfileProvider>(
      builder: (_, profileProvider, __) {
        final user = profileProvider.userProfile;
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
              const Icon(Icons.workspace_premium, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                '${user?.tokens ?? 0}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRewardsList() {
    return Consumer<RewardsProvider>(
      builder: (context, rewardsProvider, _) {
        if (rewardsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (rewardsProvider.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${rewardsProvider.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadRewards,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Get the appropriate rewards list based on type
        final List<Reward> rewards = widget.rewardType == RewardType.club
            ? rewardsProvider.clubRewards
            : rewardsProvider.featuredRewards;

        if (rewards.isEmpty) {
          return const Center(
            child: Text('No rewards available at the moment.'),
          );
        }

        // Use a grid layout for better space utilization
        return RefreshIndicator(
          onRefresh: () => rewardsProvider.loadAllRewardsData(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75, // Adjust for your card dimensions
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: rewards.length,
            itemBuilder: (context, index) {
              return _buildRewardCard(rewards[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildRewardCard(Reward reward) {
    return GestureDetector(
      onTap: () => _showRewardDetails(reward),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 120, // Fixed height for image
                width: double.infinity,
                child: Image.network(
                  "${AppConfig.imageBaseUrl}${reward.image}",
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, _) => Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      reward.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reward.itemName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Price and arrow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00C853), Color(0xFF00B0FF)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Group2.svg',
                                height: 12,
                              ),
                              SizedBox(width: 2),
                              Text(
                                reward.priceInTokens,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Color(0xffE9E9E9),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: Colors.grey[700],
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
    );
  }

  void _showRewardDetails(Reward reward) {
    final rewardsProvider =
    Provider.of<RewardsProvider>(context, listen: false);
    final profileProvider =
    Provider.of<ProfileProvider>(context, listen: false);
    final userPoints = profileProvider.userProfile?.tokens ?? 0;
    final hasEnoughPoints = userPoints >= int.parse(reward.priceInTokens);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  // Reward image
                  if (reward.image != null)
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          '${AppConfig.imageBaseUrl}${reward.image}',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, error, _) => Container(
                            height: 180,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Center(child: Icon(Icons.error)),
                          ),
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: Icon(Icons.image)),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Reward title
                  Text(
                    reward.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Reward description
                  Text(
                    reward.itemName,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Points required
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF00C853),
                            // Green
                            Color(0xFF00B0FF),
                            // Blue
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '${reward.priceInTokens} points required',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Your points
                  Center(
                    child: Text(
                      'Your points: $userPoints',
                      style: TextStyle(
                        fontSize: 16,
                        color: hasEnoughPoints ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Error message
                  Consumer<RewardsProvider>(
                    builder: (context, provider, _) {
                      if (provider.errorMessage.isNotEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            provider.errorMessage,
                            style: TextStyle(color: Colors.red.shade800),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // Redeem button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: hasEnoughPoints ? Colors.green : Colors.grey,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: hasEnoughPoints
                        ? () async {
                      if (rewardsProvider.isLoading) return;

                      final success = await rewardsProvider.redeemReward(reward.id);
                      if (success) {
                        Navigator.pop(context);
                        _showSuccessDialog(reward);
                      }
                    }
                        : null,
                    child: rewardsProvider.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Redeem Now'),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog(Reward reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Redemption Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'You have successfully redeemed ${reward.title}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}