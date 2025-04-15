import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:primax/screen/profile/user_profilescreen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          UserAccountsDrawerHeader(

            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: Padding(
              padding: const EdgeInsets.only(left: 16.0,top: 16),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/Nola_Risk.png'), // Replace with your asset image
              ),
            ),
            accountName: Padding(
              padding: const EdgeInsets.only(left: 0,),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0,),
                child: Text("Madison Smith",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
            accountEmail: Padding(
              padding: const EdgeInsets.only(left: 16.0,),
              child: Text("madison43@gmail.com"),
            ),
          ),
          GestureDetector(
              onTap: (){
                UserProfileScreen().launch(context,pageRouteAnimation: PageRouteAnimation.Slide,);

               // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfileScreen()));
              },
              child: DrawerItem(icon: SvgPicture.asset("assets/icons/user.svg"), text: "My Profile")),
          DrawerItem(icon: SvgPicture.asset("assets/icons/Group_1.svg"), text: "Message Center"),
          DrawerItem(icon: SvgPicture.asset("assets/icons/Group_5.svg"), text: "Account Ledger"),
          Divider(
            indent: 35,endIndent: 25,
          ),
          DrawerItem(icon: SvgPicture.asset("assets/icons/Group_2.svg"), text: "Terms and Conditions"),
          DrawerItem(icon:SvgPicture.asset("assets/icons/Group_3.svg"), text: "Privacy Policy"),
          DrawerItem(icon: SvgPicture.asset("assets/icons/Group_4.svg"), text: "Contact Support"),
          Divider(indent: 35,endIndent: 25,),
          DrawerItem(icon:SvgPicture.asset("assets/icons/Sign_Out.svg"), text: "Sign Out", color: Colors.red),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final Widget icon;
  final String text;
  final Color? color;

  const DrawerItem({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0,),
      child: ListTile(
        leading:icon,
        title: Text(text, style: TextStyle(fontWeight: FontWeight.w500,color: color ?? Color(0xff858EA9))),
        onTap: () {
          // Add navigation functionality here
        },
      ),
    );
  }
}
