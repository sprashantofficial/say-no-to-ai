import 'package:freezed_annotation/freezed_annotation.dart';

part 'submission_model.freezed.dart';
part 'submission_model.g.dart';

@freezed
class SubmissionModel with _$SubmissionModel {
  const factory SubmissionModel({
    required String approach,
    required String dataStructure,
    required String timeComplexity,
    required String edgeCases,
    @Default(false) bool viewedHint1,
    @Default(false) bool viewedHint2,
    @Default(false) bool viewedFinalApproach,
    @Default(false) bool viewedSampleCode,
  }) = _SubmissionModel;

  factory SubmissionModel.fromJson(Map<String, dynamic> json) => _$SubmissionModelFromJson(json);
}
