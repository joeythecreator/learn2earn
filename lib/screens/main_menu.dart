import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';
import 'games_screen.dart';
import 'edit_language_screen.dart';
import 'leaderboard_screen.dart';
import 'rewards_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _points = 0;
  String _language = '❓';
  String _username = 'Player';
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedPoints = prefs.getInt('totalPoints') ?? 0;
    final savedLang = prefs.getString('selectedLanguage') ?? '❓';
    final savedName = prefs.getString('leaderboardUsername') ?? 'Player';
    final path = prefs.getString('profileImagePath');

    File? profileFile;
    if (path != null && File(path).existsSync()) {
      profileFile = File(path);
    }

    if (!mounted) return;
    setState(() {
      _points = savedPoints;
      _language = savedLang;
      _username = savedName;
      _profileImage = profileFile;
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
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/editProfilePicture')
                              .then((result) {
                            if (result == true) {
                              _loadAllData();
                            }
                          });
                        },
                        child: CircleAvatar(
                          key: ValueKey(_profileImage?.path ?? 'default'),
                          radius: 24,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              _profileImage != null ? FileImage(_profileImage!) : null,
                          child: _profileImage == null
                              ? const Icon(Icons.person, color: Colors.deepPurple)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _username,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Reward Points: $_points',
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
                        _loadAllData();
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
        onPressed: () async {
          switch (label) {
            case 'Settings':
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
              break;
            case 'Games':
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GamesScreen()),
              );
              _loadAllData();
              break;
            case 'Rewards':
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RewardsScreen()),
              );
              _loadAllData();
              break;
            case 'Leaderboard':
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
              );
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
