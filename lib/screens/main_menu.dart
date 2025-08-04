import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';
import 'games_screen.dart';
import 'edit_language_screen.dart'; // Import for navigating to language selector

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _points = 0;
  String _language = '❓';

  @override
  void initState() {
    super.initState();
    _loadPoints();
    _loadLanguage();
  }

  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPoints = prefs.getInt('totalPoints') ?? 0;
    debugPrint('Loaded totalPoints: $savedPoints');
    setState(() {
      _points = savedPoints;
    });
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('selectedLanguage') ?? '❓';
    setState(() {
      _language = savedLang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3e236e),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              // Top Row with Profile, Points, and Language
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.deepPurple),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Points: $_points',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditLanguageScreen()),
                      ).then((_) {
                        _loadLanguage(); // reload after returning
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _language,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Four Buttons
              _buildMenuButton(context, 'Games'),
              const SizedBox(height: 20),
              _buildMenuButton(context, 'Rewards'),
              const SizedBox(height: 20),
              _buildMenuButton(context, 'Leaderboard'),
              const SizedBox(height: 20),
              _buildMenuButton(context, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          switch (label) {
            case 'Settings':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
              break;
            case 'Games':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GamesScreen()),
              ).then((_) {
                _loadPoints(); // Reload points after game ends
              });
              break;
            case 'Rewards':
              // TODO: Add navigation to RewardsScreen
              break;
            case 'Leaderboard':
              // TODO: Add navigation to LeaderboardScreen
              break;
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
