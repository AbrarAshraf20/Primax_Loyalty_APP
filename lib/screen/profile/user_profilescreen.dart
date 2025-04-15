import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserProfileScreen extends StatelessWidget {
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
          child: Column(
            children: [
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    SizedBox(width: 70,),
                    Text(
                      'User Profile',
                      style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                    ),

                  ],
                ),
              ),

              // Profile Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/images/Nola_Risk.png'), // Replace with actual image
                    ),
                    SizedBox(height: 8),
                    Text("Madison Smith",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("ID: 2503024", style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 6),
                    Container(
                      width: 90,
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
              SizedBox(height: 16),

              // Verification & QR Code Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),color: Color(0xffF3F3F3)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatusButton(SvgPicture.asset("assets/icons/Group_c.svg"), "Verified", Colors.green),
                        _buildStatusButton(SvgPicture.asset("assets/icons/Group_b.svg"), "Installer", Colors.red),
                        _buildStatusButton(SvgPicture.asset("assets/icons/Group_a.svg"), "QR Code", Colors.black),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Notification Box
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(

                      colors: [
                        const Color(0xFF00C853), // Default green
                        const Color(0xFF00B0FF), // Default blue
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/icons/Notification_icon.svg",color: Colors.white,),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("New Messages",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text("You get registration points - 300pts",
                                style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      SvgPicture.asset("assets/icons/Vector.svg",color: Colors.white,height: 30,),
                      //Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Menu Items
              _buildMenuItem("Personal Information", SvgPicture.asset("assets/icons/user.svg",color: Colors.black87,), context),
              _buildMenuItem("Address",SvgPicture.asset("assets/icons/home_a.svg",color: Colors.black87,), context),
              _buildMenuItem("Claimed Points", SvgPicture.asset("assets/icons/Frame_a.svg",color: Colors.black87,), context),
              _buildMenuItemWithSwitch("Notifications",SvgPicture.asset("assets/icons/Notifications.svg",color: Colors.black87,), context),
              _buildMenuItem("Change Password", SvgPicture.asset("assets/icons/Fats_Delivery.svg",color: Colors.black87,),context),

              SizedBox(height: 20),
              Divider(
                color: Colors.black,
                thickness: 1.5,
                indent: 20,endIndent: 20,
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text("Sign Out", style: TextStyle(color: Colors.red)),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(Widget icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          radius: 22,
          child: icon,
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12,color: color)),
      ],
    );
  }

  Widget _buildMenuItem(String title, Widget icon, BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
      trailing: Icon(Icons.arrow_forward_ios, size: 18),
      onTap: () {},
    );
  }

  Widget _buildMenuItemWithSwitch(String title,Widget icon, BuildContext context) {
    return ListTile(
      leading:icon,
      title: Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
      trailing: Switch(value: true,
         // activeColor: Colors.blue,
          activeTrackColor: Colors.blue,
          onChanged: (value) {}),
    );
  }
}
