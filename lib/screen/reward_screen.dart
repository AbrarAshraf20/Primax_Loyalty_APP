

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:primax/widgets/custom_button.dart';

class RewardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/LuckyDraw.png"), // Ensure the correct path
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20,),
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
                              borderRadius: BorderRadius.circular(20)),
                          child: SvgPicture.asset("assets/icons/Back.svg")),
                    ),
                    Text(
                      'Club Rewards',
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
                SizedBox(height: 20,),
                _buildLuckyDrawCard(context),
              ],
            ),
          ),
        ),
      ),

    );
  }

 /* AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white70,
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
        ),
        child: CircleAvatar(
            radius: 3,
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back_ios)),
      ),
      title: Text('    Club Rewards',
          style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Container(
            margin: EdgeInsets.only(right: 16),
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
                Text('160', style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.white)),
              ],
            ),
          ),
        )
      ],
    );
  }*/

  Widget _buildLuckyDrawCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClubRewardsDetailScreen()),
        );
      },
      child: Column(children: [Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffF4F4F6),
            //border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child:
                Image.asset('assets/images/Frame62.png', fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('It has survived not',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(
                            'It has survived not only five centuries, \nbut also the leap into electronic',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                      ],
                    ),
                    SizedBox(
                      width: 48,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: Color(0xffE9E9E9),
                          child: SvgPicture.asset('assets/icons/Vector.svg'),
                        ),

                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),SizedBox(height: 10),
        Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffF4F4F6),
            //border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child:
                Image.asset('assets/images/Frame_62.png', fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('It has survived not',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(
                            'It has survived not only five centuries, \nbut also the leap into electronic',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                      ],
                    ),
                    SizedBox(
                      width: 48,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: Color(0xffE9E9E9),
                          child: SvgPicture.asset('assets/icons/Vector.svg'),
                        ),

                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
        SizedBox(height: 10),
        Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffF4F4F6),
            //border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child:
                Image.asset('assets/images/Frame_1.png', fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('It has survived not',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(
                            'It has survived not only five centuries, \nbut also the leap into electronic',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                      ],
                    ),
                    SizedBox(
                      width: 48,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: Color(0xffE9E9E9),
                          child: SvgPicture.asset('assets/icons/Vector.svg'),
                        ),

                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),SizedBox(height: 10),
        Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffF4F4F6),
            //border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child:
                Image.asset('assets/images/Frame_2.png', fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('It has survived not',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(
                            'It has survived not only five centuries, \nbut also the leap into electronic',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                      ],
                    ),
                    SizedBox(
                      width: 48,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: Color(0xffE9E9E9),
                          child: SvgPicture.asset('assets/icons/Vector.svg'),
                        ),

                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),],)
    );
  }


}

class ClubRewardsDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        leading:  Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
          ),
          child: CircleAvatar(
              radius: 3,
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back_ios)),
        ),
        title: Text('   Lucky Draw',style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [ Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Container(

            margin: EdgeInsets.only(right: 16),
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
                Text('160', style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.white)),
              ],
            ),
          ),
        )],
      ),*/
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/LuckyDraw.png"), // Ensure the correct path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16),
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
                    'View Promotion',
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(10),
                child: Container(height: 450,
                  decoration: BoxDecoration(
                    color: Color(0xffF4F4F6),
                    //border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/images/Frame3.png', fit: BoxFit.cover),
                      SizedBox(height: 15),
                      Text('Honda 125 cc Bike',
                          style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      Text('Redeem the reward of Honda 125 cc Bike',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                      SizedBox(height: 20),
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/endtoend1.png',
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(width: 8),
                          Text('Lucky Draw has ended',
                              style: TextStyle(fontSize: 16, color: Colors.orange)),
                        ],
                      ),*/
                      /*SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/image116.png',
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(height: 20),
                            Text('Here is the Winners',
                                style: TextStyle(fontSize: 16, color: Colors.blue)),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/image116.png',
                            width: 60,
                            height: 60,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Muhammad Umar', style: TextStyle(fontSize: 16)),
                              Text('Umarah Package', style: TextStyle(fontSize: 10)),

                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              'assets/images/Mask_group.png',
                              width: 80,
                              height: 80,
                            ),
                          ),
                        ],
                      ),*/
                      Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 16),
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
                            Text('160', style: TextStyle(fontSize:20,fontWeight:FontWeight.bold,color: Colors.white)),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text('Points Required'),SizedBox(height: 20,),
                      CustomButton(
                          width: double.infinity,
                          text: "Redeem", onPressed: (){})
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}

