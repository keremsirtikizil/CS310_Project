import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_list/utils/AppColors.dart';
import 'package:grocery_list/utils/navbar.dart';
import 'package:grocery_list/utils/appBar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logout failed: ${e.toString()}"),
        ),
      );
    }
  }

  Widget buildSettingTile(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.boxColor,
          border: const Border(
            bottom: BorderSide(width: 2, color: Colors.black),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: const AppBarWithArrow(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            //Image.asset('assets/images/grocery+_logo.png', height: 60), no need we have it in appbar
            const SizedBox(height: 10),
            const Text(
              "Settings",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.boxColor,
                ),
                child: Column(
                  children: [
                    buildSettingTile(Icons.person_outline, "Account", () {}),
                    buildSettingTile(Icons.notifications_none, "Notifications", () {}),
                    buildSettingTile(Icons.lock_outline, "Privacy & Security", () {}),
                    buildSettingTile(Icons.remove_red_eye_outlined, "Appearance", () {}),
                    buildSettingTile(Icons.headphones_outlined, "Help & Support", () {}),
                    InkWell(
                      onTap: () => _logout(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          children: const [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 20),
                            Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const AppNavBar(currentIndex: 4),
    );
  }
}
