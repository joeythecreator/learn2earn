import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FillInTheBlankGame extends StatefulWidget {
  const FillInTheBlankGame({super.key});

  @override
  State<FillInTheBlankGame> createState() => _FillInTheBlankGameState();
}

class _FillInTheBlankGameState extends State<FillInTheBlankGame> {
  final List<Map<String, dynamic>> _allQuestions = [
    {
      'question': 'Ciao, ___ chiamo',
      'correct': 'mi',
      'options': ['mi', 'io', 'vogliono', 'buona'],
    },
    {
      'question': 'Io ___ italiano.',
      'correct': 'parlo',
      'options': ['parlo', 'parliamo', 'parlate', 'parla'],
    },
    {
      'question': 'Dove ___ il bagno?',
      'correct': 'è',
      'options': ['è', 'sono', 'hai', 'siamo'],
    },
    {
      'question': 'Lei ___ una pizza.',
      'correct': 'mangia',
      'options': ['mangia', 'mangio', 'mangiamo', 'mangiano'],
    },
    {
      'question': 'Noi ___ andare al cinema.',
      'correct': 'vogliamo',
      'options': ['vogliamo', 'voglio', 'vuole', 'vogliono'],
    },
    {
      'question': 'Il gatto ___ sul divano.',
      'correct': 'dorme',
      'options': ['dorme', 'dormiamo', 'dormono', 'dormi'],
    },
    {
      'question': 'Che ___ è oggi?',
      'correct': 'giorno',
      'options': ['giorno', 'libro', 'casa', 'scarpa'],
    },
    {
      'question': 'Lei ha ___ fame!',
      'correct': 'molta',
      'options': ['molta', 'molte', 'molto', 'molti'],
    },
    {
      'question': 'La macchina ___ rossa.',
      'correct': 'è',
      'options': ['è', 'sono', 'siamo', 'sei'],
    },
    {
      'question': 'Tu ___ andare con me?',
      'correct': 'vuoi',
      'options': ['vuoi', 'voglio', 'vuole', 'vogliamo'],
    },
  ];

  late List<Map<String, dynamic>> _questions;
  int _currentIndex = 0;
  int _score = 0;
  bool _secondTry = false;
  late List<String> _shuffledOptions;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    _questions = List.from(_allQuestions);
    _questions.shuffle(Random());
    _prepareOptions();
  }

  void _prepareOptions() {
    _secondTry = false;
    _feedback = null;
    _shuffledOptions = List<String>.from(_questions[_currentIndex]['options']);
    _shuffledOptions.shuffle(Random());
  }

  void _answer(String choice) {
    final correct = _questions[_currentIndex]['correct'] as String;

    setState(() {
      if (choice == correct) {
        if (!_secondTry) {
          _score += 2;
        } else {
          _score += 1;
        }
        _nextQuestion();
      } else {
        if (!_secondTry) {
          _feedback = 'Wrong, try again!';
          _secondTry = true;
        } else {
          _feedback = 'Wrong again! Moving on.';
          _nextQuestion();
        }
      }
    });
  }

  void _nextQuestion() {
    _currentIndex++;
    if (_currentIndex < _questions.length) {
      _prepareOptions();
    } else {
      _showScoreDialog();
    }
  }

  Future<void> _showScoreDialog() async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing total points and redeemable points, default to 0
    int currentTotal = prefs.getInt('totalPoints') ?? 0;
    int currentRedeemable = prefs.getInt('redeemablePoints') ?? 0;

    // Add current score to both totals
    int updatedTotal = currentTotal + _score;
    int updatedRedeemable = currentRedeemable + _score;

    // Save updated points
    await prefs.setInt('totalPoints', updatedTotal);
    await prefs.setInt('redeemablePoints', updatedRedeemable);
    await prefs.setInt('lastScore', _score);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Text(
          'Your score is $_score out of ${_questions.length * 2}.\n'
          'Total points: $updatedTotal\n'
          'Redeemable points: $updatedRedeemable',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _score = 0;
                _currentIndex = 0;
                _questions.shuffle(Random());
                _prepareOptions();
              });
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _questions.length) {
      return const SizedBox();
    }
    final question = _questions[_currentIndex]['question'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fill in the Blank'),
        backgroundColor: const Color(0xFF7a00e5),
      ),
      backgroundColor: const Color(0xFF3e236e),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              question,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 30),
            if (_feedback != null)
              Text(
                _feedback!,
                style: const TextStyle(
                  color: Colors.yellowAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            const SizedBox(height: 20),
            ..._shuffledOptions.map(
              (option) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => _answer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
