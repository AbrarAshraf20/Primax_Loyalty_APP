// lib/screen/reward_screen.dart
import 'package:flutter/material.dart';
import 'package:primax/core/providers/rewards_provider.dart';
import 'package:provider/provider.dart';
import '../core/providers/profile_provider.dart';
import '../core/utils/app_config.dart';
import '../models/reward_model.dart';
import '../widgets/custom_button.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({Key? key}) : super(key: key);

  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load rewards data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Load all rewards data at once
    await Provider.of<RewardsProvider>(context, listen: false).loadAllRewardsData();
  }

  @override
  Widget build(BuildContext context) {
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
              _buildAppBar(),

              // Tab bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.green,
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: 'Club Rewards'),
                    Tab(text: 'Featured Rewards'),
                  ],
                ),
              ),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildClubRewardsTab(),
                    _buildFeaturedRewardsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Container(
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

          // Title
          const Text(
            'Club Rewards',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          // Points display
          Consumer<ProfileProvider>(
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
                    Text('1',
                      // '${user?.points ?? 0}',
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
    );
  }

  Widget _buildClubRewardsTab() {
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
                  onPressed: _loadData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (rewardsProvider.clubRewards.isEmpty) {
          return const Center(
            child: Text('No club rewards available at the moment.'),
          );
        }

        return _buildRewardsList(rewardsProvider.clubRewards);
      },
    );
  }

  Widget _buildFeaturedRewardsTab() {
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
                  onPressed: _loadData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (rewardsProvider.featuredRewards.isEmpty) {
          return const Center(
            child: Text('No featured rewards available at the moment.'),
          );
        }

        return _buildRewardsList(rewardsProvider.featuredRewards);
      },
    );
  }

  Widget _buildRewardsList(List<Reward> rewards) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        return _buildRewardCard(rewards[index]);
      },
    );
  }

  Widget _buildRewardCard(Reward reward) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    // final userPoints = profileProvider.userProfile?.points ?? 0;
    // final hasEnoughPoints = userPoints >= reward.pointsRequired;

    return GestureDetector(
      onTap: () {
        _showRewardDetails(reward);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: reward.image != null
                  ? Image.network(
                "${AppConfig.imageBaseUrl}${reward.image}",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, _) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.error)),
                ),
              )
                  : Container(
                height: 180,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.image)),
              ),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reward.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reward.itemName,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Points required
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF00C853), // Green
                              Color(0xFF00B0FF), // Blue
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${reward.priceInTokens} pts',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Colors.grey[800],
                        ),
                      ),
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

  void _showRewardDetails(Reward reward) {
    final rewardsProvider = Provider.of<RewardsProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    // final userPoints = profileProvider.userProfile?.points ?? 0;
    // final hasEnoughPoints = userPoints >= reward.pointsRequired;

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
                          '${AppConfig.imageBaseUrl}images/claimables/Islamic Pilgrimage Elegant Hajj Kaaba Picture PNG Images _ PNG Free Download - Pikbest.jpg',
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
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF00C853), // Green
                            Color(0xFF00B0FF), // Blue
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
                      'Your points: "userPoints"',
                      style: TextStyle(
                        fontSize: 16,
                        color: true ? Colors.green : Colors.red,
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
                  CustomButton(
                    text: rewardsProvider.isLoading ? 'Processing...' : 'Redeem Now',
                    width: double.infinity,
                    isLoading: rewardsProvider.isLoading,
                    onPressed:()=> true
                        ? () async {
                      final success = await rewardsProvider.redeemReward(reward.id);
                      if (success) {
                        Navigator.pop(context);
                        _showSuccessDialog(reward);
                      }
                    }
                        : null,
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