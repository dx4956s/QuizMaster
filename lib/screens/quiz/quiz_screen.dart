import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/models/quiz_category.dart';
import 'package:quiz_app/screens/end/end_screen.dart';
import 'package:quiz_app/screens/quiz/widgets/option_button.dart';
import 'package:quiz_app/screens/quiz/widgets/timer_bar.dart';
import 'package:quiz_app/services/score_service.dart';
import 'package:quiz_app/widgets/app_background.dart';
import 'package:timer_count_down/timer_controller.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory category;

  const QuizScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  int _score = 0;
  final List<bool> _answers = [];
  late final CountdownController _timerController;

  bool _answered = false;
  int? _selectedIndex;

  int get _totalQuestions => widget.category.questions.length;

  @override
  void initState() {
    super.initState();
    _timerController = CountdownController(autoStart: true);
  }

  Question get _currentQuestion => widget.category.questions[_index];

  int get _correctIndex =>
      _currentQuestion.options.indexOf(_currentQuestion.answer);

  OptionState _optionState(int i) {
    if (!_answered) return OptionState.normal;
    if (i == _correctIndex) return OptionState.correct;
    if (i == _selectedIndex) return OptionState.wrong;
    return OptionState.dimmed;
  }

  void _checkAnswer(int optionIndex) {
    if (_answered) return;

    final isCorrect = optionIndex == _correctIndex;
    if (isCorrect) {
      _score += 10;
    } else if (_score > 0) {
      _score -= 5;
    }
    _answers.add(isCorrect);

    setState(() {
      _answered = true;
      _selectedIndex = optionIndex;
    });

    _timerController.pause();
    Future.delayed(const Duration(milliseconds: 900), _goNext);
  }

  void _onTimerFinished() {
    if (_answered) return;
    _answers.add(false);
    setState(() {
      _answered = true;
      _selectedIndex = null;
    });
    Future.delayed(const Duration(milliseconds: 400), _goNext);
  }

  void _goNext() {
    if (!mounted) return;
    if (_index == _totalQuestions - 1) {
      _finishQuiz();
    } else {
      setState(() {
        _index++;
        _answered = false;
        _selectedIndex = null;
        _timerController.restart();
      });
    }
  }

  void _finishQuiz() {
    ScoreService.addScore(_score);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => EndScreen(
          score: _score,
          answers: _answers,
          category: widget.category,
        ),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final q = _currentQuestion;

    return PopScope(
      canPop: false,
      child: AppBackground(
        child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────
              Container(
                color: widget.category.color,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(widget.category.icon,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          widget.category.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        // Score chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '$_score',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Question counter
                        Text(
                          '${_index + 1}/$_totalQuestions',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // Progress dots
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(_totalQuestions, (i) {
                        Color dotColor;
                        if (i < _answers.length) {
                          dotColor = _answers[i]
                              ? Colors.greenAccent
                              : Colors.redAccent;
                        } else if (i == _index) {
                          dotColor = Colors.white;
                        } else {
                          dotColor = Colors.white30;
                        }
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            height: 4,
                            decoration: BoxDecoration(
                              color: dotColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              // ── Timer ────────────────────────────────────────────────────
              TimerBar(
                controller: _timerController,
                onFinished: _onTimerFinished,
              ),

              // ── Question card ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(0.08, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                          parent: anim, curve: Curves.easeOut)),
                      child: child,
                    ),
                  ),
                  child: Card(
                    key: ValueKey(_index),
                    margin: EdgeInsets.zero,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        q.question,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── Options ──────────────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: q.options.length,
                  itemBuilder: (_, i) => OptionButton(
                    key: ValueKey('$_index-$i'),
                    text: q.options[i],
                    index: i,
                    state: _optionState(i),
                    onPressed: _answered ? null : () => _checkAnswer(i),
                  )
                      .animate(delay: (i * 70).ms)
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
