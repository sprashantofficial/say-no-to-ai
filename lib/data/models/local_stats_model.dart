import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_stats_model.freezed.dart';
part 'local_stats_model.g.dart';

@freezed
class LocalStatsModel with _$LocalStatsModel {
  const factory LocalStatsModel({
    required String? lastActiveDate,
    @Default(0) int streak,
    @Default(0) int totalAttempts,
    @Default(0) int totalHintsUsed,
    @Default(0) int totalIndependentSolves,
    @Default(false) bool isPremium,
  }) = _LocalStatsModel;

  factory LocalStatsModel.fromJson(Map<String, dynamic> json) => _$LocalStatsModelFromJson(json);
}
