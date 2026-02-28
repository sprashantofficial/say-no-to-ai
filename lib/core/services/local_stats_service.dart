import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/local_stats_model.dart';

final localStatsServiceProvider = Provider<LocalStatsService>((ref) {
  throw UnimplementedError('Overridden in main.dart');
});

class LocalStatsService {
  LocalStatsService._(this.preferences);

  final SharedPreferences preferences;

  static Future<LocalStatsService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStatsService._(prefs);
  }

  LocalStatsModel readStats() {
    return LocalStatsModel(
      lastActiveDate: preferences.getString('lastActiveDate'),
      streak: preferences.getInt('streak') ?? 0,
      totalAttempts: preferences.getInt('totalAttempts') ?? 0,
      totalHintsUsed: preferences.getInt('totalHintsUsed') ?? 0,
      totalIndependentSolves: preferences.getInt('totalIndependentSolves') ?? 0,
      isPremium: preferences.getBool('isPremium') ?? false,
    );
  }

  Future<void> incrementAttemptAndUpdateStreak() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final last = preferences.getString('lastActiveDate');
    var streak = preferences.getInt('streak') ?? 0;

    if (last == null) {
      streak = 1;
    } else {
      final lastDate = DateFormat('yyyy-MM-dd').parse(last);
      final nowDate = DateFormat('yyyy-MM-dd').parse(today);
      final delta = nowDate.difference(lastDate).inDays;
      if (delta == 1) {
        streak += 1;
      } else if (delta > 1) {
        streak = 1;
      }
    }

    await preferences.setString('lastActiveDate', today);
    await preferences.setInt('streak', streak);
    await preferences.setInt('totalAttempts', (preferences.getInt('totalAttempts') ?? 0) + 1);
  }

  Future<void> incrementHintsUsed() async {
    await preferences.setInt('totalHintsUsed', (preferences.getInt('totalHintsUsed') ?? 0) + 1);
  }

  Future<void> incrementIndependentSolve() async {
    await preferences.setInt('totalIndependentSolves', (preferences.getInt('totalIndependentSolves') ?? 0) + 1);
  }

  Future<void> savePremium(bool value) => preferences.setBool('isPremium', value);
}
