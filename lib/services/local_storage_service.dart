import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learn2earn/models/leaderboard_entry.dart';

class LocalStorageService {
  static const String leaderboardKey = 'leaderboard_entries';

  static Future<List<LeaderboardEntry>> loadLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(leaderboardKey);

    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => LeaderboardEntry.fromJson(e)).toList();
  }

  static Future<void> saveLeaderboard(List<LeaderboardEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(leaderboardKey, jsonString);
  }

  static Future<void> addOrUpdateEntry(LeaderboardEntry newEntry) async {
    List<LeaderboardEntry> entries = await loadLeaderboard();
    final index = entries.indexWhere((e) => e.username == newEntry.username);

    if (index >= 0) {
      // Update existing
      entries[index] = newEntry;
    } else {
      // Add new
      entries.add(newEntry);
    }

    // Sort by score descending
    entries.sort((a, b) => b.score.compareTo(a.score));
    await saveLeaderboard(entries);
  }
}
