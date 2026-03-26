import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quiz_app/models/quiz_category.dart';
import 'package:quiz_app/screens/end/widgets/result_card.dart';
import 'package:quiz_app/screens/home/home_screen.dart';
import 'package:quiz_app/screens/quiz/quiz_screen.dart';
import 'package:quiz_app/services/high_score_service.dart';
import 'package:quiz_app/services/score_service.dart';
import 'package:quiz_app/widgets/app_background.dart';

class EndScreen extends StatefulWidget {
  final int score;
  final List<bool> answers;
  final QuizCategory category;

  const EndScreen({
    Key? key,
    required this.score,
    required this.answers,
    required this.category,
  }) : super(key: key);

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  @override
  void initState() {
    super.initState();
    _saveScore();
  }

  Future<void> _saveScore() async {
    try {
      await HighScoreService.saveIfHighScore(widget.category.id, widget.score);
    } catch (e) {
      debugPrint('HighScoreService error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save score: $e')),
        );
      }
    }
  }

  int get score => widget.score;
  List<bool> get answers => widget.answers;
  QuizCategory get category => widget.category;

  int get _maxScore => category.questions.length * 10;
  int get _correct => answers.where((a) => a).length;
  double get _percent => (score / _maxScore).clamp(0.0, 1.0);

  String get _performanceLabel {
    if (_percent >= 0.9) return '🏆 Excellent!';
    if (_percent >= 0.7) return '👏 Great job!';
    if (_percent >= 0.5) return '👍 Good effort!';
    return '📚 Keep practising!';
  }

  Color get _scoreColor {
    if (_percent >= 0.7) return const Color(0xFF2E7D32);
    if (_percent >= 0.5) return const Color(0xFFF57F17);
    return const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      child: AppBackground(
        child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // ── Score card ─────────────────────────────────────────────
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      category.color,
                      Color.lerp(category.color, Colors.black, 0.3)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: category.color.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Category label
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category.icon, color: Colors.white70, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            category.name,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Score gauge + count-up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Animated circular gauge
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: _percent),
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeOut,
                            builder: (_, value, __) =>
                                CircularPercentIndicator(
                              radius: 60,
                              lineWidth: 10,
                              percent: value,
                              center: TweenAnimationBuilder<int>(
                                tween: IntTween(begin: 0, end: score),
                                duration: const Duration(milliseconds: 1200),
                                curve: Curves.easeOut,
                                builder: (_, val, __) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$val',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'pts',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              progressColor: Colors.white,
                              backgroundColor: Colors.white24,
                            ),
                          ),

                          // Stats column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _StatRow(
                                icon: Icons.check_circle_outline_rounded,
                                iconColor: Colors.greenAccent,
                                label: 'Correct',
                                value: '$_correct / ${category.questions.length}',
                              ),
                              const SizedBox(height: 10),
                              _StatRow(
                                icon: Icons.cancel_outlined,
                                iconColor: Colors.redAccent,
                                label: 'Wrong',
                                value:
                                    '${category.questions.length - _correct} / ${category.questions.length}',
                              ),
                              const SizedBox(height: 10),
                              _StatRow(
                                icon: Icons.star_rounded,
                                iconColor: Colors.amber,
                                label: 'Total pts',
                                value: '${ScoreService.totalScore}',
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Performance message
                      Text(
                        _performanceLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                    color: Colors.white38, width: 1.5),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Icon(Icons.grid_view_rounded),
                              label: const Text('Categories'),
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HomeScreen()),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: category.color,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Icon(Icons.replay_rounded),
                              label: const Text('Play Again'),
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      QuizScreen(category: category),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate().slideY(begin: -0.2, duration: 500.ms, curve: Curves.easeOut).fadeIn(),

              // ── Review list ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    const Icon(Icons.list_alt_rounded, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Answer Review',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: category.questions.length,
                  itemBuilder: (_, i) => ResultCard(
                    question: category.questions[i],
                    isCorrect: answers[i],
                    index: i,
                  )
                      .animate(delay: (i * 50 + 300).ms)
                      .slideX(begin: 0.15, duration: 350.ms, curve: Curves.easeOut)
                      .fadeIn(duration: 300.ms),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(color: Colors.white60, fontSize: 11)),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ],
        ),
      ],
    );
  }
}
