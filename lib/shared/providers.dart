import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/firebase_problem_datasource.dart';
import '../data/repositories/problem_repository.dart';
import '../data/repositories/problem_repository_impl.dart';
import '../data/models/problem_model.dart';

final firebaseDatabaseProvider = Provider<FirebaseDatabase>((_) => FirebaseDatabase.instance);

final problemDatasourceProvider = Provider<FirebaseProblemDatasource>(
  (ref) => FirebaseProblemDatasource(ref.read(firebaseDatabaseProvider)),
);

final problemRepositoryProvider = Provider<ProblemRepository>(
  (ref) => ProblemRepositoryImpl(ref.read(problemDatasourceProvider)),
);

final allProblemsProvider = FutureProvider<List<ProblemModel>>(
  (ref) => ref.read(problemRepositoryProvider).getAllProblems(),
);

final dailyProblemProvider = FutureProvider<ProblemModel?>((ref) {
  final date = DateTime.now().toIso8601String().split('T').first;
  return ref.read(problemRepositoryProvider).getDailyChallenge(date);
});

final submissionStateProvider = StateProvider<Map<String, dynamic>>((_) => {});
final revealStepProvider = StateProvider.family<int, String>((_, __) => 0);
