import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quiz_app/data/categories.dart';
import 'package:quiz_app/models/quiz_category.dart';
import 'package:quiz_app/services/high_score_service.dart';
import 'package:quiz_app/widgets/app_background.dart';

class HighScoreScreen extends StatefulWidget {
  const HighScoreScreen({Key? key}) : super(key: key);

  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  late Future<Map<String, int>> _scoresFuture;

  @override
  void initState() {
    super.initState();
    _scoresFuture = HighScoreService.getAllScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(child: FutureBuilder<Map<String, int>>(
        future: _scoresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final scores = snapshot.data ?? {};
          final totalBest = scores.values.fold(0, (a, b) => a + b);
          final played = scores.length;
          final maxPossible = categories.length * 100;

          return CustomScrollView(
            slivers: [
              // ── App bar ──────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                backgroundColor: const Color(0xFF6C63FF),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF6C63FF), Color(0xFF3D35CC)],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            const Text(
                              'High Scores',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _SummaryChip(
                                  icon: Icons.emoji_events_rounded,
                                  iconColor: Colors.amber,
                                  label: 'Best Total',
                                  value: '$totalBest pts',
                                ),
                                const SizedBox(width: 10),
                                _SummaryChip(
                                  icon: Icons.category_rounded,
                                  iconColor: Colors.lightGreenAccent,
                                  label: 'Played',
                                  value: '$played / ${categories.length}',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // ── Section title ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Text(
                    'Your best score per subject',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              // ── Score rows ────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final cat = categories[index];
                      final best = scores[cat.id] ?? 0;
                      final maxScore = cat.questions.length * 10;
                      return _ScoreRow(
                        category: cat,
                        best: best,
                        maxScore: maxScore,
                        index: index,
                      );
                    },
                    childCount: categories.length,
                  ),
                ),
              ),
            ],
          );
        },
      )),
    );
  }
}

// ── Summary chip ──────────────────────────────────────────────────────────────

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white60, fontSize: 10)),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Score row ─────────────────────────────────────────────────────────────────

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({
    required this.category,
    required this.best,
    required this.maxScore,
    required this.index,
  });

  final QuizCategory category;
  final int best;
  final int maxScore;
  final int index;

  bool get _played => best > 0;
  double get _percent => _played ? (best / maxScore).clamp(0.0, 1.0) : 0;

  Color get _barColor {
    if (_percent >= 0.8) return const Color(0xFF2E7D32);
    if (_percent >= 0.5) return const Color(0xFFF57F17);
    return const Color(0xFFC62828);
  }

  String get _grade {
    if (!_played) return '–';
    if (_percent >= 0.9) return 'A+';
    if (_percent >= 0.8) return 'A';
    if (_percent >= 0.7) return 'B';
    if (_percent >= 0.5) return 'C';
    return 'D';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(category.icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),

            // Name + progress bar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        _played ? '$best / $maxScore' : 'Not played',
                        style: TextStyle(
                          fontSize: 12,
                          color: _played
                              ? cs.onSurface.withOpacity(0.75)
                              : cs.onSurface.withOpacity(0.35),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: _percent),
                      duration: Duration(milliseconds: 700 + index * 60),
                      curve: Curves.easeOut,
                      builder: (_, value, __) => LinearProgressIndicator(
                        value: value,
                        minHeight: 8,
                        backgroundColor: cs.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation(
                          _played ? _barColor : cs.outline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Grade badge
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _played
                    ? _barColor.withOpacity(0.18)
                    : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _played ? _barColor.withOpacity(0.4) : cs.outline,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _grade,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: _played ? _barColor : cs.onSurface.withOpacity(0.35),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: (index * 50 + 200).ms)
        .slideX(begin: 0.15, duration: 350.ms, curve: Curves.easeOut)
        .fadeIn(duration: 300.ms);
  }
}
