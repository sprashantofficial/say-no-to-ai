import 'package:freezed_annotation/freezed_annotation.dart';

part 'problem_model.freezed.dart';
part 'problem_model.g.dart';

@freezed
class ProblemModel with _$ProblemModel {
  const factory ProblemModel({
    required String id,
    required String title,
    required String description,
    required String difficulty,
    required String topic,
    required String hint1,
    required String hint2,
    required String finalApproach,
    required String sampleJavaCode,
  }) = _ProblemModel;

  factory ProblemModel.fromJson(Map<String, dynamic> json) => _$ProblemModelFromJson(json);
}
