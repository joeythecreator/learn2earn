import 'dart:convert';

class LeaderboardEntry {
  final String username;
  final int score;
  final String? profileImagePath;

  LeaderboardEntry({
    required this.username,
    required this.score,
    this.profileImagePath,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'score': score,
    'profileImagePath': profileImagePath,
  };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      username: json['username'],
      score: json['score'],
      profileImagePath: json['profileImagePath'],
    );
  }
}