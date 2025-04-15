import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:primax/screen/scan/veryfiyserial.dart';
import 'package:primax/widgets/custom_button.dart';

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/LuckyDraw.png"),
            // Ensure the correct path
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0,right: 5 ),
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
                                borderRadius: BorderRadius.circular(20)),
                            child: SvgPicture.asset("assets/icons/Back.svg")),
                      ),
                      Text(
                        'Scan for Rewards',
                        style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                      ),
                      Container(
                        //margin: EdgeInsets.only(right: 16),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,  // Start color at the top
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF00C853), // Default green
                              const Color(0xFF00B0FF), // Default blue
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/icons/Group2.svg'),
                            SizedBox(width: 4),
                            Text('160', style: TextStyle(fontWeight:FontWeight.bold,color: Colors.white)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildScanCard(),
                SizedBox(height: 20),
                _buildBarcodeInput(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanCard() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, // Start color at the top
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF00B0FF), // Default blue
              const Color(0xFF00C853), // Default green
            ],
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            SvgPicture.asset(
              'assets/icons/XMLID.svg', // Replace with actual asset
              height: 120,
            ),
            SizedBox(height: 30),
            Text(
              "Scan Product Barcode",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              "Use Camera to scan Privex card & add Loyalty points to your account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            SizedBox(height: 25),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Center(
                  child: Text(
                "Scan Now",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildBarcodeInput(context) {
    return Card(
      color: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Close Button
                              // Close Button
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Image.asset(
                                    'assets/images/image120.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Image.asset('assets/images/image116.png'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),

                              // Title
                              Text(
                                "Congratulations",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "You Have Earned",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 5),

                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 5.0),
                                child: Container(
                                  width: 90,
                                  margin: EdgeInsets.only(right: 16),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      // Start color at the top
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color(0xFF00C853),
                                        // Default green
                                        const Color(0xFF00B0FF),
                                        // Default blue
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/Group2.svg'),
                                      SizedBox(width: 4),
                                      Text('160',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Points",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Image.asset(
                  'assets/images/Untitled.png',
                  scale: 5,
                )),
            SizedBox(height: 20),
            Text(
              "Enter Product Barcode",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                hintText: "Insert Card Number",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Use Camera to scan Privex card & add Loyalty points to your account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
            SizedBox(height: 20),
            CustomButton(
                width: double.infinity,
                text: "Submit",
                onPressed: () {
                  VerifySerial().launch(
                    context,
                    pageRouteAnimation: PageRouteAnimation.Slide,
                  );
                }),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
