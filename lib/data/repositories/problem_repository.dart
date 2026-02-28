import '../models/problem_model.dart';

abstract class ProblemRepository {
  Future<List<ProblemModel>> getAllProblems();
  Future<ProblemModel?> getDailyChallenge(String isoDate);
}
