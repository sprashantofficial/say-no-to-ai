import 'package:intl/intl.dart';

import '../../core/utils/iterable_ext.dart';

import '../datasources/firebase_problem_datasource.dart';
import '../models/problem_model.dart';
import 'problem_repository.dart';

class ProblemRepositoryImpl implements ProblemRepository {
  ProblemRepositoryImpl(this._datasource);

  final FirebaseProblemDatasource _datasource;

  @override
  Future<List<ProblemModel>> getAllProblems() => _datasource.fetchProblems();

  @override
  Future<ProblemModel?> getDailyChallenge(String isoDate) async {
    final all = await getAllProblems();
    if (all.isEmpty) {
      return null;
    }

    final explicitId = await _datasource.fetchDailyChallengeId(isoDate);
    if (explicitId != null) {
      return all.where((problem) => problem.id == explicitId).firstOrNull;
    }

    final dayIndex = DateFormat('yyyy-MM-dd').parse(isoDate).difference(DateTime(2024, 1, 1)).inDays;
    return all[dayIndex % all.length];
  }
}
