import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'profile/drawer.dart';

class HomeScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildProfileSection(context),
      ),

      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/LuckyDraw.png"), // Ensure the correct path
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBannerSection(),
              _buildSectionTitle("Club Rewards"),
              _buildClubRewards(context),
              _buildSectionTitle("Features Rewards"),
              _buildFeatureRewards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: (){
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomDrawer()));
              },
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/Nola_Risk.png"), // Replace with NetworkImage for real images
                radius: 20,

              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome,", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text("Joe Sava", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
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
    );
  }

  Widget _buildBannerSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset("assets/images/Frame3.png", fit: BoxFit.cover), // Replace with your image asset
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text("View All", style: TextStyle(color: Colors.blue, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildClubRewards(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset("assets/images/Rectangle23.png",width: MediaQuery.of(context).size.height * 0.65, fit: BoxFit.cover), // Replace with actual image
      ),
    );
  }

  Widget _buildFeatureRewards() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4, // Change based on items
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Color(0xffF4F4F6),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("assets/images/Frame11.png",width: 140, fit: BoxFit.cover), // Replace with actual image
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Led TV Redeem", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Container(
                          width: 60,height: 30,
                          margin: EdgeInsets.only(right: 16),
                          padding: EdgeInsets.symmetric( vertical: 6),
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
                        ),

                        CircleAvatar(
                        radius: 15,
                        backgroundColor: Color(0xffE9E9E9),
                        child: SvgPicture.asset('assets/icons/Vector.svg'),
                      ),],)
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
