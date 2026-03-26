import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class TimerBar extends StatelessWidget {
  final CountdownController controller;
  final VoidCallback onFinished;
  static const int _totalSeconds = 10;

  const TimerBar({
    Key? key,
    required this.controller,
    required this.onFinished,
  }) : super(key: key);

  Color _barColor(double remaining) {
    if (remaining > 6) return const Color(0xFF2E7D32); // green
    if (remaining > 3) return const Color(0xFFF57F17); // amber
    return const Color(0xFFC62828); // red
  }

  @override
  Widget build(BuildContext context) {
    return Countdown(
      controller: controller,
      seconds: _totalSeconds,
      interval: const Duration(milliseconds: 100),
      onFinished: onFinished,
      build: (_, double time) {
        final percent = (time / _totalSeconds).clamp(0.0, 1.0);
        final color = _barColor(time);

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 52, 16, 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, color: color, size: 18),
                      const SizedBox(width: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: time <= 3 ? 18 : 14,
                        ),
                        child: Text('${time.ceil()}s'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                barRadius: const Radius.circular(8),
                percent: percent,
                backgroundColor: const Color(0xFF2C2C3E),
                progressColor: color,
                lineHeight: 10,
                animation: false,
              ),
            ],
          ),
        );
      },
    );
  }
}
