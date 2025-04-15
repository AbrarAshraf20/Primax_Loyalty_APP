/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/utils/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text__form_field.dart';
import '../dashboard_screen/dashboard_screen.dart';
import '../login_screen/login_screen.dart';

class VerifySerial extends StatefulWidget {
  // Role: Installer, Dealer, or Distributor
  const VerifySerial({Key? key}) : super(key: key);

  @override
  State<VerifySerial> createState() => _VerifySerialState();
}

class _VerifySerialState extends State<VerifySerial> {
  bool isEmailSelected = true;
  bool isPasswordVisible = false;
  bool isKeepSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Verify Serial ',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),



            const SizedBox(height: 20),
            Text('Name',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              // decoration: InputDecoration(
              hintText: 'Name',
              hintStyle: TextStyle(color: Colors.grey),

            ),
            const SizedBox(height: 20),
            Text('Mobile',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              // decoration: InputDecoration(
              hintText:   'Mobile',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),
              hintStyle: TextStyle(color: Colors.grey),
              // ),
            ),
            const SizedBox(height: 20),
            Text('Item',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              obscureText: !isPasswordVisible,
              hintStyle: TextStyle(color: Colors.grey),
              // decoration: InputDecoration(
              hintText: 'Item',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // )
               suffix: IconButton(
                                 icon: SvgPicture.asset('assets/icons/MainIcon.svg'),
                                 onPressed: () {}
                             ),

              // ),
            ),
            const SizedBox(height: 20),
            Text('City',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              // decoration: InputDecoration(
              hintText: 'City',
              hintStyle: TextStyle(color: Colors.grey),
              suffix: IconButton(
                  icon: SvgPicture.asset('assets/icons/MainIcon.svg'),
                  onPressed: () {}
              ),

            ),
            const SizedBox(height: 20),
            Text('Customer Name',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              // decoration: InputDecoration(
              hintText: 'Customer name',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),
              hintStyle: TextStyle(color: Colors.grey),

            ),
            const SizedBox(height: 20),
            Text('Customer Contact info',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              obscureText: !isPasswordVisible,
              hintStyle: TextStyle(color: Colors.grey),
              // decoration: InputDecoration(
              hintText: 'Customer Contact info',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),

              // ),
            ),
            const SizedBox(height: 20),
            Text('Customer address',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Customer address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
            const SizedBox(height: 20),
            Text('Upload Pics of Installation Site',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              obscureText: !isPasswordVisible,
              hintStyle: TextStyle(color: Colors.grey),
              // decoration: InputDecoration(
              hintText: 'Dreg file her',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),
               suffix: Container(
                 width: 120,height: 50,
                 decoration: BoxDecoration( 
                   borderRadius: BorderRadius.circular(5),
                   gradient: LinearGradient(

                   colors: [
                     const Color(0xFF00C853), // Default green
                     const Color(0xFF00B0FF), // Default blue
                   ],
                 ),),
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [Image.asset(
                   'assets/images/folder.png',scale: 2, // Replace with actual asset

                                  ),

                     Text('Browse...',style: TextStyle(color: Colors.white),)],),
                 ),),
              // ),
            ),
            const SizedBox(height: 20),
            Text('Remarks',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              obscureText: !isPasswordVisible,
              hintStyle: TextStyle(color: Colors.grey),
              // decoration: InputDecoration(
              hintText: 'Remarks',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),

              // ),
            ),

            const SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                // Handle login
                DashboardScreen().launch(context,pageRouteAnimation: PageRouteAnimation.Slide,);

              },
              width: double.maxFinite,
              text:'Save',
            ),

          ],
        ),
      ),
    );
  }
}*/



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/utils/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text__form_field.dart';
import '../dashboard_screen/dashboard_screen.dart';

class VerifySerial extends StatefulWidget {
  const VerifySerial({Key? key}) : super(key: key);

  @override
  State<VerifySerial> createState() => _VerifySerialState();
}

class _VerifySerialState extends State<VerifySerial> {
  bool isPasswordVisible = false;

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                            borderRadius: BorderRadius.circular(20)),
                        child: SvgPicture.asset("assets/icons/Back.svg")),
                  ),
                  Text(
                    'Verify Serial',
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
              const SizedBox(height: 10),

              Text('Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                hintText: 'Name',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              Text('Mobile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                hintText: 'Mobile',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              Text('Item', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                hintText: 'Item',
                hintStyle: TextStyle(color: Colors.grey),
                suffix: IconButton(
                  icon: SvgPicture.asset('assets/icons/MainIcon.svg'),
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),

              Text('City', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                hintText: 'City',
                hintStyle: TextStyle(color: Colors.grey),
                suffix: IconButton(
                  icon: SvgPicture.asset('assets/icons/MainIcon.svg'),
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),

              Text('Customer Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                hintText: 'Customer name',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              Text('Customer Contact info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                hintText: 'Customer Contact info',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              Text('Customer address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Customer address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),
              const SizedBox(height: 20),

              Text('Upload Pics of Installation Site', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                hintText: 'Drag file here',
                hintStyle: TextStyle(color: Colors.grey),
                suffix: Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF00C853), // Default green
                        const Color(0xFF00B0FF), // Default blue
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/images/folder.png', scale: 2),
                        Text('Browse...', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text('Remarks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              CustomTextFormField(
                hintText: 'Remarks',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              CustomButton(
                onPressed: () {
                  DashboardScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                },
                width: double.infinity,
                text: 'Save',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
