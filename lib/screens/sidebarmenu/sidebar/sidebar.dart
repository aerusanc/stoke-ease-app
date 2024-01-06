// sidebar.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login/login_screen.dart';
import 'package:flutter_application_1/screens/sidebarmenu/menu_input.dart';
import 'package:flutter_application_1/screens/sidebarmenu/menu_profile.dart';
import 'package:flutter_application_1/screens/sidebarmenu/menu_report.dart';
import 'package:flutter_application_1/screens/toast.dart';
import 'sidebar_button.dart';


class Sidebar extends StatelessWidget {
  static const Color primaryColor = const Color.fromARGB(255, 2, 101, 208);
  static const Color accentColor = Color.fromARGB(255, 255, 255, 255);
  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          // Sidebar
          Container(
            width: 250, // Sesuaikan lebar sidebar sesuai kebutuhan
            color: accentColor,
            child: ListView(
              children: [
                SidebarHeader(),
                SidebarButton(
                  icon: Icons.account_circle,
                  label: 'Profile', 
                  onPressed: () => print('Profile button pressed'), destination: ProfilePage(),
                  ),
                SidebarButton(
                  icon: Icons.assignment,
                  label: 'Input Barang',
                  onPressed: () => print('Input button pressed'), destination: InputPage(),
                  ),
                  SidebarButton(
                  icon: Icons.description,
                  label: 'Laporan',
                  onPressed: () => print('Laporan button pressed'), destination: ImageUpload(),
                  ),
                  SidebarButton(
                    icon:Icons.logout,
                    label:'Log Out',
                    onPressed:() {
                      FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, "/login");
                showToast(message: "Successfully signed out");
              }, destination: LoginPage(),
                    
                  )
                // Tambahkan tombol sidebar lainnya sesuai kebutuhan
              ],
            ),
          ),
        ],
      );
  }
}


