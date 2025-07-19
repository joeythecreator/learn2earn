import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();

    // Check if user is already signed in
    Future.delayed(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is signed in - replace with actual home screen later
        // For now just show a success message or stay on this screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User already signed in')),
        );
      } else {
        // No user signed in, go to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Welcome to Learn 2 Earn!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }
}
