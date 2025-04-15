import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text__form_field.dart';

class DonationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: _buildAppBar(),*/
      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/LuckyDraw.png"),
            // Ensure the correct path
            fit: BoxFit.cover,
          ),
        ),
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
                    'Donation',
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
    );
  }

  /*AppBar _buildAppBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
        ),
        child: CircleAvatar(
            radius: 3,
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back_ios)),
      ),
      title:
          Text('      Donation', style: TextStyle(fontWeight: FontWeight.bold)),
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
                Text('160', style: TextStyle(fontWeight:FontWeight.bold,color: Colors.white)),
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
          MaterialPageRoute(builder: (context) => DonationDetailScreen()),
        );
      },
      child: Column(
        children: [
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.asset('assets/images/Frame4.png',
                        fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('JDC Foundation Pakistan',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: Color(0xffE9E9E9),
                              child:
                                  SvgPicture.asset('assets/icons/Vector.svg'),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 18,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.asset('assets/images/Frame1.png',
                        fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Romaan Raees Foundation',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: Color(0xffE9E9E9),
                              child:
                                  SvgPicture.asset('assets/icons/Vector.svg'),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 18,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DonationDetailScreen extends StatelessWidget {
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
                    'Donation',
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.67,
                  decoration: BoxDecoration(
                    color: Color(0xffF4F4F6),
                    //border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/images/Frame2.png', fit: BoxFit.cover),
                      SizedBox(height: 15),
                      Text('Romaan Raees Foundation',
                          style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Details about Romaan Raees Foundation',
                          style: TextStyle(fontSize: 13, color: Colors.grey[900])),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50.0),
                        child: Container(
                            width: double.infinity,
                            height: 45,
                            //margin: EdgeInsets.only(right: 16),
                            padding:
                                EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              /* gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF00C853), // Default green
                                  const Color(0xFF00B0FF), // Default blue
                                ],
                              ),*/
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                // Add border here
                                color: Colors.green,
                                // Change this to any color you prefer
                                width: 2, // Border width
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.watch_later_outlined),SizedBox(width: 15,),
                                Center(
                                    child: Text(
                                  'Added on 10/03/24',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ))
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Container(
                          width: 85,
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
                              Text('160',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text('Points Required'),
                      SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Close Button
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          icon: Image.asset('assets/images/image120.png',width: 30,height: 30,),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),

                                      // Title
                                      Text(
                                        "Making Donation",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      SizedBox(height: 15),

                                      // Name Input
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Name (on behalf of)",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText: "Name here",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        ),
                                      ),

                                      SizedBox(height: 15),

                                      // Message Input
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Type Your Message",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      TextField(
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          hintText: "Type Your Message",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        ),
                                      ),

                                      SizedBox(height: 15),

                                      // Donation Amount
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                             SvgPicture.asset('assets/icons/Group2.svg'),
                                            SizedBox(width: 5),
                                            Text(
                                              "30",
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 15),

                                      // Donate Button
                                      CustomButton(text: 'Donate', onPressed: (){}),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20.0),
                          child: Container(
                              width: double.infinity,
                              height: 45,
                              //margin: EdgeInsets.only(right: 16),
                              padding:
                                  EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF00C853), // Default green
                                    const Color(0xFF00B0FF), // Default blue
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                  child: Text(
                                'Donate',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))),
                        ),
                      ),
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





