import 'package:flutter/material.dart';
import 'package:quiz_app/data/quiz_data/biology_questions.dart';
import 'package:quiz_app/data/quiz_data/chemistry_questions.dart';
import 'package:quiz_app/data/quiz_data/civics_questions.dart';
import 'package:quiz_app/data/quiz_data/computer_questions.dart';
import 'package:quiz_app/data/quiz_data/geography_questions.dart';
import 'package:quiz_app/data/quiz_data/history_questions.dart';
import 'package:quiz_app/data/quiz_data/law_questions.dart';
import 'package:quiz_app/data/quiz_data/philosophy_questions.dart';
import 'package:quiz_app/data/quiz_data/physics_questions.dart';
import 'package:quiz_app/data/quiz_data/psychology_questions.dart';
import 'package:quiz_app/models/quiz_category.dart';

const List<QuizCategory> categories = [
  QuizCategory(
    id: 'computer',
    name: 'Computer',
    icon: Icons.computer,
    color: Color(0xFF1565C0),
    questions: computerQuestions,
  ),
  QuizCategory(
    id: 'physics',
    name: 'Physics',
    icon: Icons.electric_bolt,
    color: Color(0xFFF57F17),
    questions: physicsQuestions,
  ),
  QuizCategory(
    id: 'chemistry',
    name: 'Chemistry',
    icon: Icons.science,
    color: Color(0xFF6A1B9A),
    questions: chemistryQuestions,
  ),
  QuizCategory(
    id: 'biology',
    name: 'Biology',
    icon: Icons.biotech,
    color: Color(0xFF2E7D32),
    questions: biologyQuestions,
  ),
  QuizCategory(
    id: 'history',
    name: 'History',
    icon: Icons.account_balance,
    color: Color(0xFF4E342E),
    questions: historyQuestions,
  ),
  QuizCategory(
    id: 'geography',
    name: 'Geography',
    icon: Icons.public,
    color: Color(0xFF00695C),
    questions: geographyQuestions,
  ),
  QuizCategory(
    id: 'civics',
    name: 'Civics',
    icon: Icons.gavel,
    color: Color(0xFFAD1457),
    questions: civicsQuestions,
  ),
  QuizCategory(
    id: 'philosophy',
    name: 'Philosophy',
    icon: Icons.psychology_alt,
    color: Color(0xFF283593),
    questions: philosophyQuestions,
  ),
  QuizCategory(
    id: 'psychology',
    name: 'Psychology',
    icon: Icons.psychology,
    color: Color(0xFFE65100),
    questions: psychologyQuestions,
  ),
  QuizCategory(
    id: 'law',
    name: 'Law',
    icon: Icons.balance,
    color: Color(0xFF37474F),
    questions: lawQuestions,
  ),
];
