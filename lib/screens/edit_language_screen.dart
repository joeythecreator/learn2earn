import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditLanguageScreen extends StatelessWidget {
  const EditLanguageScreen({super.key});

  Future<void> _selectLanguage(BuildContext context, String languageEmoji) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageEmoji);
    Navigator.of(context).pop(); // Go back to Main Menu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        backgroundColor: const Color(0xFF7a00e5),
      ),
      backgroundColor: const Color(0xFF3e236e),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _selectLanguage(context, '🇮🇹'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            '🇮🇹 Italian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}
