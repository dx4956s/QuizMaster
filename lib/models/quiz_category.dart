import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';

class QuizCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<Question> questions;

  const QuizCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.questions,
  });
}
