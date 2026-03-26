import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class HighScoreService {
  static final _db = FirebaseFirestore.instance;

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  /// Saves [score] for [categoryId] only if it beats the existing high score.
  /// Returns true if a new high score was written.
  static Future<bool> saveIfHighScore(String categoryId, int score) async {
    if (_uid == null) {
      debugPrint('HighScoreService: skipped — user not logged in');
      return false;
    }
    if (score <= 0) {
      debugPrint('HighScoreService: skipped — score is $score');
      return false;
    }
    final ref = _db.collection('highscores').doc(_uid);
    final doc = await ref.get();
    final existing = (doc.data()?[categoryId] as num?)?.toInt() ?? 0;
    if (score > existing) {
      await ref.set({categoryId: score}, SetOptions(merge: true));
      debugPrint('HighScoreService: saved $categoryId = $score (was $existing)');
      return true;
    }
    debugPrint('HighScoreService: no update — $score <= existing $existing');
    return false;
  }

  /// Returns a map of categoryId → high score for the current user.
  static Future<Map<String, int>> getAllScores() async {
    if (_uid == null) return {};
    final doc = await _db.collection('highscores').doc(_uid).get();
    if (!doc.exists) return {};
    return (doc.data() ?? {}).map(
      (key, value) => MapEntry(key, (value as num).toInt()),
    );
  }
}
