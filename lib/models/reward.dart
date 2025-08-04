class Reward {
  final String companyName;
  final String description;
  final int pointsCost;

  Reward({
    required this.companyName,
    required this.description,
    required this.pointsCost,
  });

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'description': description,
        'pointsCost': pointsCost,
      };

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        companyName: json['companyName'],
        description: json['description'],
        pointsCost: json['pointsCost'],
      );
}
