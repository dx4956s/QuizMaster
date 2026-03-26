import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';

class ResultCard extends StatelessWidget {
  final Question question;
  final bool isCorrect;
  final int index;

  const ResultCard({
    Key? key,
    required this.question,
    required this.isCorrect,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFEF5350);
    final bgColor = isCorrect
        ? const Color(0xFF1B3320)
        : const Color(0xFF3B1C1C);
    final icon = isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.35), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Index + icon
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(width: 12),
            // Note text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCorrect ? 'Correct!' : 'Incorrect',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    question.note,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFCCCCCC),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
