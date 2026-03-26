import 'package:get_storage/get_storage.dart';

class ScoreService {
  static final _storage = GetStorage();
  static const _key = 'TotalScore';

  static int get totalScore => _storage.read<int>(_key) ?? 0;

  static void addScore(int score) {
    _storage.write(_key, totalScore + score);
  }
}
