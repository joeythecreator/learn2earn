import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';
import 'games_screen.dart';
import 'edit_language_screen.dart';
import 'leaderboard_screen.dart';
import 'rewards_screen.dart'; // <-- added import

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> with RouteAware {
  int _points = 0;
  String _language = '❓';
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAllData();
  }

  void _loadAllData() {
    _loadPoints();
    _loadLanguage();
    _loadProfileImage();
  }

  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPoints = prefs.getInt('totalPoints') ?? 0;
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

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profileImagePath');
    if (path != null && File(path).existsSync()) {
      setState(() {
        _profileImage = File(path);
      });
    } else {
      setState(() {
        _profileImage = null;
      });
    }
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/editProfilePicture')
                          .then((result) {
                        if (result != null && result == true) {
                          _loadProfileImage();
                        }
                      });
                    },
                    child: CircleAvatar(
                      key: ValueKey(_profileImage?.path ?? 'default'),
                      radius: 24,
                      backgroundColor: Colors.white,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(Icons.person, color: Colors.deepPurple)
                          : null,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        MaterialPageRoute(
                            builder: (_) => const EditLanguageScreen()),
                      ).then((_) {
                        _loadLanguage();
                      });
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                _loadPoints();
              });
              break;
            case 'Rewards':
              // Navigate to RewardsScreen, then reload points after return
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RewardsScreen()),
              );
              _loadPoints();
              break;
            case 'Leaderboard':
              Navigator.push(
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
