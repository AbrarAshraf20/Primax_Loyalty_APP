import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../core/utils/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text__form_field.dart';
import '../login_screen/login_screen.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({Key? key}) : super(key: key);

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  bool isEmailSelected = true;
  bool isPasswordVisible = false;
  bool isKeepSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Set Password',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            /*const Text(
              'Enter tour Email address to get the password reset link',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),*/

            // Row(
            //   children: [
            //     GestureDetector(
            //       onTap: () => setState(() => isEmailSelected = true),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'Email',
            //             style: TextStyle(
            //               fontSize: 16,
            //               color: isEmailSelected ? Colors.green : Colors.black,
            //               fontWeight: isEmailSelected
            //                   ? FontWeight.bold
            //                   : FontWeight.normal,
            //             ),
            //           ),
            //           if (isEmailSelected)
            //             Container(
            //               margin: const EdgeInsets.only(top: 4),
            //               height: 2,
            //               width: 50,
            //               color: Colors.green,
            //             ),
            //         ],
            //       ),
            //     ),
            //     const SizedBox(width: 30),
            //     GestureDetector(
            //       onTap: () => setState(() => isEmailSelected = false),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'Phone Number',
            //             style: TextStyle(
            //               fontSize: 16,
            //               color: !isEmailSelected ? Colors.green : Colors.black,
            //               fontWeight: !isEmailSelected
            //                   ? FontWeight.bold
            //                   : FontWeight.normal,
            //             ),
            //           ),
            //           if (!isEmailSelected)
            //             Container(
            //               margin: const EdgeInsets.only(top: 4),
            //               height: 2,
            //               width: 90,
            //               color: Colors.green,
            //             ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 50),
            Text('Enter new Password',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
            const SizedBox(height: 5),
            CustomTextFormField(
              obscureText: !isPasswordVisible,
              // decoration: InputDecoration(
              hintText: 'New Password',
              hintStyle: TextStyle(color: Colors.grey),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),
              suffix: IconButton(
                icon: Icon(
                  isPasswordVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,color: Colors.black,
                ),
                onPressed: () =>
                    setState(() => isPasswordVisible = !isPasswordVisible),
              ),
              // ),
            ),
            const SizedBox(height: 50),
            Text('Re-enter new Password',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
            const SizedBox(height: 5),
            CustomTextFormField(
              obscureText: !isPasswordVisible,
              // decoration: InputDecoration(
              hintText: 'Re-enter Password',
              hintStyle: TextStyle(color: Colors.grey),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              // ),
              suffix: IconButton(
                icon: Icon(
                  isPasswordVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,color: Colors.black,
                ),
                onPressed: () =>
                    setState(() => isPasswordVisible = !isPasswordVisible),
              ),
              // ),
            ),
            const SizedBox(height: 50),
            CustomButton(
              onPressed: () {
                // Handle login
              },
              width: double.maxFinite,
              text:'Continue',
            ),
            const SizedBox(height: 40),
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
                        text: 'Sign in her',
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
                const SizedBox(width: 5),
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
                ),const SizedBox(width: 5),
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