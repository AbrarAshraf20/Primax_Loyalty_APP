import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/core/utils/app_config.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:primax/core/providers/points_provider.dart';
import 'package:primax/models/claimed_point.dart';

class ClaimedPointsScreen extends StatefulWidget {
  const ClaimedPointsScreen({Key? key}) : super(key: key);

  @override
  State<ClaimedPointsScreen> createState() => _ClaimedPointsScreenState();
}

class _ClaimedPointsScreenState extends State<ClaimedPointsScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    Future.microtask(() {
      Provider.of<PointsProvider>(context, listen: false).refreshPointsData();
    });
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
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildPointsSummary(context),
              const SizedBox(height: 20),
              Expanded(
                child: _buildTransactionsList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                icon: const Icon(Icons.arrow_back_ios, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          const Text(
            'Claimed Points',
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
                      '${profileProvider.userProfile?.tokens}',
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

  Widget _buildPointsSummary(BuildContext context) {
    return Consumer<PointsProvider>(
      builder: (context, pointsProvider, _) {
        // Calculate total consumed points and claims count
        int totalClaims = pointsProvider.claimedPoints.length;
        int totalConsumedPoints = 0;
        for (var claimedPoint in pointsProvider.claimedPoints) {
          totalConsumedPoints += int.tryParse(claimedPoint.tokenPrice) ?? 0;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00C853), // Green
                Color(0xFF00B0FF), // Blue
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Consumed Points',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$totalConsumedPoints',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/Group2.svg',
                      height: 24,
                      width: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Transactions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${pointsProvider.claimedPoints.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionsList(BuildContext context) {
    return Consumer<PointsProvider>(
      builder: (context, pointsProvider, _) {
        if (pointsProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (pointsProvider.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  pointsProvider.errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    pointsProvider.refreshPointsData();
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (pointsProvider.claimedPoints.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/Group2.svg', // Replace with appropriate empty state icon
                  height: 64,
                  width: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No claims found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your claimed products will appear here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: pointsProvider.claimedPoints.length,
          itemBuilder: (context, index) {
            final claimedPoint = pointsProvider.claimedPoints[index];
            return _buildClaimedPointCard(context, claimedPoint);
          },
        );
      },
    );
  }
  getSelectedUTCDateTime(String utcTime) async {
    DateTime utcDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parseUtc(utcTime);
    DateTime localDateTime = utcDateTime.toLocal();
    String dataTime = DateFormat('MMM dd, yyyy • hh:mm a').format(localDateTime);
    return dataTime;
  }
  String createDate='';
Future<String> getCorrectTime(date) async {
   return await getSelectedUTCDateTime(date);

}
  Widget _buildClaimedPointCard(BuildContext context, ClaimedPoint claimedPoint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Product icon
                Container(
                  // padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      '${AppConfig.imageBaseUrl}${claimedPoint.image}',
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Middle: Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        claimedPoint.productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        claimedPoint.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      FutureBuilder<String>(
                        future: getCorrectTime(claimedPoint.createdAt.toString()),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? '...',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),

                // Right: Token Price and Serial
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Token Price
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Group2.svg',
                            height: 14,
                            width: 14,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${claimedPoint.tokenPrice}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Serial Number
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        claimedPoint.serial,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Additional details row
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildDetailItem(Icons.phone, claimedPoint.mobile),
                _buildDetailItem(Icons.location_city, claimedPoint.city),
                _buildDetailItem(Icons.confirmation_number, 'S/N: ${claimedPoint.serialNum}'),
              ],
            ),
            if (claimedPoint.customerAddress.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      claimedPoint.customerAddress,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}