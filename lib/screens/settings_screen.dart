import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_username_screen.dart';
import 'edit_email_screen.dart';
import 'edit_password_screen.dart';
import 'edit_language_screen.dart';
import 'edit_profile_picture_screen.dart'; // Correct import
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF7a00e5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSettingsButton(context, 'Username', const EditUsernameScreen()),
            const SizedBox(height: 12),
            _buildSettingsButton(context, 'Email', const EditEmailScreen()),
            const SizedBox(height: 12),
            _buildSettingsButton(context, 'Password', const EditPasswordScreen()),
            const SizedBox(height: 12),
            _buildSettingsButton(context, 'Language', const EditLanguageScreen()),
            const SizedBox(height: 12),
            _buildSettingsButton(context, 'Edit Profile Picture', const EditProfilePictureScreen()),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _signOut(context),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context, String label, Widget screen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
