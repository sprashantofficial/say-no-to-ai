import 'package:firebase_database/firebase_database.dart';

import '../models/problem_model.dart';

class FirebaseProblemDatasource {
  FirebaseProblemDatasource(this._database);

  final FirebaseDatabase _database;

  Future<List<ProblemModel>> fetchProblems() async {
    try {
      final snapshot = await _database.ref('problems').get();
      if (!snapshot.exists || snapshot.value == null) {
        return <ProblemModel>[];
      }

      final map = Map<String, dynamic>.from(snapshot.value as Map);
      return map.entries.map((entry) {
        final payload = Map<String, dynamic>.from(entry.value as Map)..['id'] = entry.key;
        return ProblemModel.fromJson(payload);
      }).toList()
        ..sort((a, b) => a.id.compareTo(b.id));
    } catch (e) {
      throw Exception('Failed to fetch problems: $e');
    }
  }

  Future<String?> fetchDailyChallengeId(String isoDate) async {
    try {
      final snapshot = await _database.ref('dailyChallenges/$isoDate').get();
      if (!snapshot.exists) {
        return null;
      }
      return snapshot.value?.toString();
    } catch (e) {
      throw Exception('Failed to fetch daily challenge: $e');
    }
  }
}
