import 'dart:io';

import 'package:flutter/material.dart';
import 'package:learn2earn/models/leaderboard_entry.dart';
import 'package:learn2earn/services/local_storage_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<LeaderboardEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final entries = await LocalStorageService.loadLeaderboard();
    entries.sort((a, b) => b.score.compareTo(a.score)); // Sort by score descending
    setState(() {
      _entries = entries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3e236e),
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: const Color(0xFF7a00e5),
      ),
      body: _entries.isEmpty
          ? const Center(
              child: Text(
                'No leaderboard data yet.',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _entries.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white24),
              itemBuilder: (context, index) {
                final entry = _entries[index];
                final rank = index + 1;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: entry.profileImagePath != null && entry.profileImagePath!.isNotEmpty
                        ? FileImage(File(entry.profileImagePath!))
                        : null,
                    child: (entry.profileImagePath == null || entry.profileImagePath!.isEmpty)
                        ? const Icon(Icons.person, color: Colors.deepPurple)
                        : null,
                  ),
                  title: Text(
                    '$rank. ${entry.username}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Text(
                    '${entry.score}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
