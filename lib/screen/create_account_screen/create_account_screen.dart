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

class CreateAccountScreen extends StatefulWidget {
  final String role; // Role: Installer, Dealer, or Distributor
  const CreateAccountScreen({Key? key,required this.role}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
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
              '${widget.role} ',
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
            Text('Email Address',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              // decoration: InputDecoration(
              hintText: isEmailSelected ? 'Enter Email Address' : 'Phone Number',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),
              hintStyle: TextStyle(color: Colors.grey),
              // ),
            ),
            const SizedBox(height: 20),
            Text('Phone Number',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              obscureText: !isPasswordVisible,
              hintStyle: TextStyle(color: Colors.grey),
              // decoration: InputDecoration(
              hintText: 'Phone Number',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),

              // ),
            ),
            const SizedBox(height: 20),
            Text('Province',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              // decoration: InputDecoration(
              hintText: 'Province',
              hintStyle: TextStyle(color: Colors.grey),
              suffix: IconButton(
                  icon: SvgPicture.asset('assets/icons/MainIcon.svg'),
                  onPressed: () {}
              ),

            ),
            const SizedBox(height: 20),
            Text('City',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              // decoration: InputDecoration(
              hintText: 'City',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),
              hintStyle: TextStyle(color: Colors.grey),
              // ),
              suffix: IconButton(
                 icon: SvgPicture.asset('assets/icons/MainIcon.svg'),
                onPressed: () {}
              ),
            ),
            const SizedBox(height: 20),
            Text('CNIC Number',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              obscureText: !isPasswordVisible,
              hintStyle: TextStyle(color: Colors.grey),
              // decoration: InputDecoration(
              hintText: 'CNIC Number',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),

              // ),
            ),
            const SizedBox(height: 20),
            Text('Company/Shop Number',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              // decoration: InputDecoration(
              hintText:'Company/Shop Number' ,
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),
              hintStyle: TextStyle(color: Colors.grey),
              // ),
            ),
            const SizedBox(height: 20),
            Text('Address',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 5),
            CustomTextFormField(
              obscureText: !isPasswordVisible,
              hintStyle: TextStyle(color: Colors.grey),
              // decoration: InputDecoration(
              hintText: 'Address',
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),

              // ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: isKeepSignedIn,
                  onChanged: (value) =>
                      setState(() => isKeepSignedIn = value ?? false),
                ),
                Expanded(
                  child: const Text.rich(
                      TextSpan(
                        text: "By Continuing, you agree to out ",
                        style: const TextStyle(color: Colors.grey,fontSize: 12),
                        children: [
                          TextSpan(
                            text: 'Terms & Condition',
                            style: const TextStyle(color: Colors.blue,fontSize: 10),
                            // Add navigation action here
                          ),
                        ],
                      ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                // Handle login
                DashboardScreen().launch(context,pageRouteAnimation: PageRouteAnimation.Slide,);

              },
              width: double.maxFinite,
              text:'Sign up',
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: (){
                LoginScreen().launch(context,pageRouteAnimation: PageRouteAnimation.Slide,);
               },
              child: Center(
                child: Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Sign in here',
                        style: const TextStyle(color: Colors.blue),
                        // Add navigation action here
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(child: Divider(color:Colors.blueGrey,indent: 2,endIndent: 10,)),
                Text('Or'),
                Expanded(child: Divider(color: Colors.blueGrey,indent: 10,endIndent: 2,)),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(40)
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Google login
                    },
                    icon: SvgPicture.asset('assets/icons/ic_google.svg'),
                  ),
                ),
                SizedBox(width: 5,),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(40)
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Apple login
                    },
                    icon: SvgPicture.asset('assets/icons/ic_apple.svg'),
                  ),
                ),
                SizedBox(width: 5,),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(40)
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Facebook login
                    },
                    icon: SvgPicture.asset('assets/icons/ic_facebook.svg'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}