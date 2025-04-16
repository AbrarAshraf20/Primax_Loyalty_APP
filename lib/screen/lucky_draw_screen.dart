// lib/screen/lucky_draw_screen.dart
import 'package:flutter/material.dart';
import 'package:primax/core/providers/lucky_draw_provider.dart';
import 'package:provider/provider.dart';
import '../core/providers/network_status_provider.dart';
import '../widgets/network_status_indicator.dart';

class LuckyDrawScreen extends StatefulWidget {
  const LuckyDrawScreen({Key? key}) : super(key: key);

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
              const SizedBox(height: 40),
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
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const Text(
                    'Lucky Draw',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF00C853),
                          Color(0xFF00B0FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '160',
                          style: TextStyle(
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

              // Lucky draw list
              Expanded(
                child: ListView.builder(
                  itemCount: provider.luckyDraws.length,
                  itemBuilder: (context, index) {
                    final draw = provider.luckyDraws[index];
                    return _buildLuckyDrawCard(context, draw);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLuckyDrawCard(BuildContext context, draw) {
    return GestureDetector(
      onTap: () {
        Provider.of<LuckyDrawProvider>(context, listen: false).selectDraw(draw);
        Navigator.pushNamed(context, '/lucky-draw-details');
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
              child: Image.network(
                draw.imageUrl,
                fit: BoxFit.cover,
                height: 180,
                width: double.infinity,
                errorBuilder: (ctx, error, _) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.error)),
                ),
              ),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          draw.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          draw.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Points circle and button
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: const Color(0xffE9E9E9),
                        child: Icon(Icons.arrow_forward),
                      ),
                      if (draw.isActive)
                        TextButton(
                          onPressed: () {
                            _showWinnerDialog(context);
                          },
                          child: const Text(
                            'Show\nWinner',
                            style: TextStyle(fontSize: 10, color: Colors.blue),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
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
}