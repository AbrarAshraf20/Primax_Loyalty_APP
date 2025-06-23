// lib/screen/reward_screen.dart
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:primax/core/providers/rewards_provider.dart';
import 'package:primax/routes/routes.dart';
import 'package:provider/provider.dart';

import '../core/providers/profile_provider.dart';
import '../core/utils/app_config.dart';
import '../models/reward_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/payment_method_selection.dart';
import '../widgets/delivery_info_form.dart';
import '../widgets/message_dialog.dart';

class RewardScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  
  const RewardScreen({Key? key, this.onBackPressed}) : super(key: key);

  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  @override
  void initState() {
    super.initState();

    // Load rewards data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // Load all rewards data at once
    await Provider.of<RewardsProvider>(context, listen: false)
        .loadAllRewardsData();
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
          bottom: false,
          child: Column(
            children: [
              _buildAppBar(),

              // Tab content
              Expanded(
                child: _buildClubRewardsTab(),
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
              onPressed: widget.onBackPressed ?? () {},
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    const Icon(Icons.workspace_premium,
                        color: Colors.white, size: 16),
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF00C853),
                              // Green
                              Color(0xFF00B0FF),
                              // Blue
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
    final rewardsProvider =
        Provider.of<RewardsProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final userPoints = profileProvider.userProfile?.tokens ?? 0;
    final hasEnoughPoints = userPoints >= int.parse(reward.priceInTokens);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        Map<String, String>? paymentInfo;
        Function()? validatePaymentForm;
        Function()? validateDeliveryForm;
        final paymentFormKey = GlobalKey<PaymentMethodSelectionState>();
        final deliveryFormKey = GlobalKey<DeliveryInfoFormState>();
        String generalErrorMessage = '';
        
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
                              Color(0xFF00B0FF),
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

                    const SizedBox(height: 30),

                    // Show different forms based on cashornot value
                    if ((reward.cashornot??'0') == "1") ...[
                      // Cash reward - show payment method selection
                      PaymentMethodSelection(
                        key: paymentFormKey,
                        onPaymentInfoChanged: (info) {
                          setState(() {
                            paymentInfo = info;
                          });
                          print('Debug: Cash payment info updated: $info');
                        },
                        onTermsPressed: () {
                          _showTermsAndConditions();
                        },
                        onValidationReady: (validationFunction) {
                          validatePaymentForm = validationFunction;
                          print('Debug: Payment validation function registered');
                        },
                      ),
                    ] else ...[
                      // Non-cash reward - show delivery info form
                      DeliveryInfoForm(
                        key: deliveryFormKey,
                        onDeliveryInfoChanged: (info) {
                          setState(() {
                            paymentInfo = info;
                          });
                          print('Debug: Non-cash delivery info updated: $info');
                        },
                        onTermsPressed: () {
                          _showTermsAndConditions();
                        },
                        onValidationReady: (validationFunction) {
                          validateDeliveryForm = validationFunction;
                          print('Debug: Delivery validation function registered');
                        },
                      ),
                    ],

                    const SizedBox(height: 30),

                    // Error messages area
                    if (generalErrorMessage.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade800, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                generalErrorMessage,
                                style: TextStyle(color: Colors.red.shade800, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),],

                    // API Error message
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
                        text: rewardsProvider.isLoading
                            ? 'Processing...'
                            : 'Redeem Now',
                        width: double.infinity,
                        isLoading: rewardsProvider.isLoading,
                        onPressed: () async {
                          print('Debug: Redeem button pressed');
                          print('Debug: Has enough points: $hasEnoughPoints');
                          print('Debug: Payment info: $paymentInfo');
                          
                          // Clear previous error
                          setState(() {
                            generalErrorMessage = '';
                          });
                          
                          // Validate form fields first
                          bool isFormValid = false;
                          
                          if ((reward.cashornot??'0') == "1") {
                            // Validate payment form
                            print('Debug: Validating payment form');
                            final paymentState = paymentFormKey.currentState;
                            if (paymentState != null) {
                              isFormValid = paymentState.validateFields();
                              print('Debug: Payment form validation result: $isFormValid');
                            } else {
                              print('Debug: Payment form state is null!');
                            }
                          } else {
                            // Validate delivery form  
                            print('Debug: Validating delivery form');
                            final deliveryState = deliveryFormKey.currentState;
                            if (deliveryState != null) {
                              isFormValid = deliveryState.validateFields();
                              print('Debug: Delivery form validation result: $isFormValid');
                            } else {
                              print('Debug: Delivery form state is null!');
                            }
                          }
                          
                          // If validation fails, don't close dialog and don't proceed
                          if (!isFormValid) {
                            print('Debug: Form validation failed, staying on dialog');
                            setState(() {
                              generalErrorMessage = 'Please fill in all required fields and agree to terms & conditions';
                            });
                            return;
                          }
                          
                          // After form is valid, check if user has enough points
                          if (!hasEnoughPoints) {
                            setState(() {
                              generalErrorMessage = "You don't have enough points to redeem this reward";
                            });
                            return;
                          }
                          
                          // If we reach here, form is valid and user has enough points
                          print('Debug: Starting redemption process for reward ${reward.id}');
                          print('Debug: Payment info: $paymentInfo');
                          
                          try {
                            final success = await rewardsProvider
                                .redeemReward(reward.id, paymentInfo!,reward.cashornot??"0");
                            
                            print('Debug: Redemption result: $success');
                            
                            Navigator.pop(context);
                            
                            if (success) {
                              // Show success dialog with API message
                              final successMessage = rewardsProvider.successMessage.isNotEmpty
                                  ? rewardsProvider.successMessage
                                  : 'Your reward "${reward.title}" has been successfully redeemed. You will receive further details via your registered contact information.';
                              
                              MessageDialog.showSuccess(
                                context: context,
                                title: 'Redemption Successful!',
                                message: successMessage,
                                buttonText: 'OK',
                                onButtonPressed: () {
                                  Navigator.pop(context);
                                  // Refresh the rewards list
                                  _loadData();
                                },
                              );
                            } else {
                              // Show error dialog with the actual error message from API
                              final errorMessage = rewardsProvider.errorMessage.isNotEmpty 
                                  ? rewardsProvider.errorMessage 
                                  : 'Unable to process your redemption at this time. Please try again later.';
                              
                              MessageDialog.showError(
                                context: context,
                                title: 'Redemption Failed',
                                message: errorMessage,
                                buttonText: 'Try Again',
                                onButtonPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                            }
                          } catch (e) {
                            print('Debug: Exception during redemption: $e');
                            Navigator.pop(context);
                            
                            // Show error dialog for exceptions
                            MessageDialog.showError(
                              context: context,
                              title: 'Something Went Wrong',
                              message: 'An unexpected error occurred while processing your request. Please check your internet connection and try again.',
                              buttonText: 'OK',
                              onButtonPressed: () {
                                Navigator.pop(context);
                              },
                            );
                          }
                        }),

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


  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'Terms and Conditions for Reward Redemption\n\n'
            '1. Rewards are subject to availability and may be discontinued without notice.\n\n'
            '2. Payment information provided must be accurate and belong to the account holder.\n\n'
            '3. Processing time for rewards may take 3-5 business days.\n\n'
            '4. The company reserves the right to verify payment information before processing.\n\n'
            '5. Rewards cannot be exchanged for cash or transferred to another account.\n\n'
            '6. By redeeming rewards, you agree to these terms and conditions.',
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
