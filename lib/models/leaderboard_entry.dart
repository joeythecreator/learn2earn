class LeaderboardEntry {
  final String userId; // new field: unique backend user ID
  final String username;
  final int score;
  final String? profileImagePath;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.score,
    this.profileImagePath,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'score': score,
        'profileImagePath': profileImagePath,
      };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'] ?? 'unknown_user_id',
      username: (json['username'] as String?)?.isNotEmpty == true
          ? json['username'] as String
          : 'unknown',
      score: json['score'] ?? 0,
      profileImagePath: json['profileImagePath'],
    );
  }
}
