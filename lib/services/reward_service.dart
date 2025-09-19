import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardService with ChangeNotifier {
  int _totalScore = 0;
  int _bestStreak = 0;
  int _totalQuestions = 0;
  int _correctAnswers = 0;
  List<Achievement> _achievements = [];

  RewardService() {
    _loadProgress();
  }

  int get totalScore => _totalScore;
  int get bestStreak => _bestStreak;
  int get totalQuestions => _totalQuestions;
  int get correctAnswers => _correctAnswers;
  double get accuracy => _totalQuestions > 0 ? (_correctAnswers / _totalQuestions) * 100 : 0;
  List<Achievement> get achievements => _achievements;

  void updateScore(int score, int streak) {
    _totalScore += score;
    _totalQuestions++;
    if (score > 0) {
      _correctAnswers++;
    }

    if (streak > _bestStreak) {
      _bestStreak = streak;
    }

    _checkAchievements();
    _saveProgress();
    notifyListeners();
  }

  void _checkAchievements() {
    final newAchievements = <Achievement>[];

    if (_totalScore >= 100 && !_achievements.any((a) => a.id == 'score_100')) {
      newAchievements.add(Achievement(
        id: 'score_100',
        title: '百分达人',
        description: '累计获得100分',
        icon: Icons.star,
      ));
    }

    if (_bestStreak >= 10 && !_achievements.any((a) => a.id == 'streak_10')) {
      newAchievements.add(Achievement(
        id: 'streak_10',
        title: '连续大师',
        description: '连续答对10题',
        icon: Icons.local_fire_department,
      ));
    }

    if (_totalQuestions >= 50 && !_achievements.any((a) => a.id == 'questions_50')) {
      newAchievements.add(Achievement(
        id: 'questions_50',
        title: '勤学苦练',
        description: '完成50道题',
        icon: Icons.school,
      ));
    }

    if (accuracy >= 80 && _totalQuestions >= 20 && !_achievements.any((a) => a.id == 'accuracy_80')) {
      newAchievements.add(Achievement(
        id: 'accuracy_80',
        title: '精准射手',
        description: '正确率达到80%',
        icon: Icons.target,
      ));
    }

    if (newAchievements.isNotEmpty) {
      _achievements.addAll(newAchievements);
    }
  }

  void resetProgress() {
    _totalScore = 0;
    _bestStreak = 0;
    _totalQuestions = 0;
    _correctAnswers = 0;
    _achievements = [];
    _saveProgress();
    notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_score', _totalScore);
    await prefs.setInt('best_streak', _bestStreak);
    await prefs.setInt('total_questions', _totalQuestions);
    await prefs.setInt('correct_answers', _correctAnswers);
    await prefs.setStringList('achievements', _achievements.map((a) => a.id).toList());
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _totalScore = prefs.getInt('total_score') ?? 0;
    _bestStreak = prefs.getInt('best_streak') ?? 0;
    _totalQuestions = prefs.getInt('total_questions') ?? 0;
    _correctAnswers = prefs.getInt('correct_answers') ?? 0;

    final achievementIds = prefs.getStringList('achievements') ?? [];
    _achievements = achievementIds.map((id) => _getAchievementById(id)).where((a) => a != null).cast<Achievement>().toList();

    notifyListeners();
  }

  Achievement? _getAchievementById(String id) {
    switch (id) {
      case 'score_100':
        return Achievement(id: 'score_100', title: '百分达人', description: '累计获得100分', icon: Icons.star);
      case 'streak_10':
        return Achievement(id: 'streak_10', title: '连续大师', description: '连续答对10题', icon: Icons.local_fire_department);
      case 'questions_50':
        return Achievement(id: 'questions_50', title: '勤学苦练', description: '完成50道题', icon: Icons.school);
      case 'accuracy_80':
        return Achievement(id: 'accuracy_80', title: '精准射手', description: '正确率达到80%', icon: Icons.target);
      default:
        return null;
    }
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });
}