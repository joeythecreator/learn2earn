import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learn2earn/models/leaderboard_entry.dart';
import 'package:learn2earn/services/local_storage_service.dart';

class EditUsernameScreen extends StatefulWidget {
  const EditUsernameScreen({super.key});

  @override
  State<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _currentUsername = '';
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUsernameAndUserId();
  }

  Future<void> _loadUsernameAndUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUsername = prefs.getString('username') ?? '';
      _userId = prefs.getString('userID'); // unique backend ID
      _usernameController.text = _currentUsername;
    });
  }

  Future<void> _saveUsername() async {
    final newUsername = _usernameController.text.trim();
    if (newUsername.isEmpty || newUsername == _currentUsername) return;
    if (_userId == null) {
      // Defensive: no userId means we cannot update correctly
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: user ID not found')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final entries = await LocalStorageService.loadLeaderboard();

    // Find current user entry by userId
    final currentIndex = entries.indexWhere((e) => e.userId == _userId);
    LeaderboardEntry? currentEntry;
    if (currentIndex >= 0) {
      currentEntry = entries[currentIndex];
      entries.removeAt(currentIndex);
    }

    // Remove any other entry with the new username to prevent duplicates
    entries.removeWhere((e) => e.username == newUsername);

    // Create updated entry with same userId, new username, preserving score & image
    final updatedEntry = LeaderboardEntry(
      userId: _userId!,
      username: newUsername,
      score: currentEntry?.score ?? 0,
      profileImagePath: currentEntry?.profileImagePath,
    );

    entries.add(updatedEntry);

    // Save updated username in prefs
    await prefs.setString('username', newUsername);

    // Save updated leaderboard
    await LocalStorageService.saveLeaderboard(entries);

    setState(() {
      _currentUsername = newUsername;
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Username Updated',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Your new username is "$newUsername"',
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
              Navigator.pop(context); 
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Username'),
        backgroundColor: const Color(0xFF3e236e),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF3e236e),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            TextField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              decoration: InputDecoration(
                labelText: 'Enter new username',
                labelStyle: const TextStyle(color: Colors.white70, fontFamily: 'Poppins'),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white70),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveUsername,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9fe600),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Username',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
