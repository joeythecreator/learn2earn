import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reward {
  final String companyName;
  final String discount;
  final int cost;

  Reward({
    required this.companyName,
    required this.discount,
    required this.cost,
  });
}

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _userPoints = 0;
  final TextEditingController _emailController = TextEditingController();

  final List<Reward> _rewards = [
    Reward(
      companyName: 'Sakura Sushi',
      discount: '25% off dinner (6pm or later)',
      cost: 5,
    ),
    Reward(
      companyName: 'Flight Club',
      discount: '10% off Air Jordans (Must use by 9/30/2024)',
      cost: 10,
    ),
    Reward(
      companyName: 'FashionNova.com',
      discount: 'Free shipping (no min. order required)',
      cost: 20,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final points = prefs.getInt('totalPoints') ?? 0;

    setState(() {
      _userPoints = points;
    });
  }

  Future<void> _claimReward(Reward reward) async {
    if (_userPoints < reward.cost) {
      _showDialog('Not enough points', 'You need ${reward.cost} points to claim this reward.');
      return;
    }

    _emailController.clear(); // Clear before showing dialog

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Enter Email',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email you want reward sent to:',
            labelStyle: TextStyle(fontFamily: 'Poppins'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final enteredEmail = _emailController.text.trim();
              if (enteredEmail.isEmpty || !enteredEmail.contains('@')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid email address')),
                );
                return;
              }

              final prefs = await SharedPreferences.getInstance();
              final newPoints = _userPoints - reward.cost;
              await prefs.setInt('totalPoints', newPoints);

              setState(() {
                _userPoints = newPoints;
              });

              Navigator.pop(context);

              _showDialog(
                'Reward Claimed!',
                '${reward.companyName} reward has been sent to:\n\n$enteredEmail',
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3e236e),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Rewards',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You have $_userPoints points',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _rewards.length,
                itemBuilder: (context, index) {
                  final reward = _rewards[index];
                  final canClaim = _userPoints >= reward.cost;

                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reward.companyName,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            reward.discount,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${reward.cost} points',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: canClaim ? () => _claimReward(reward) : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: canClaim ? Colors.deepPurple : Colors.grey,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Claim',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
