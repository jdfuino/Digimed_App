import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_cardiovascular.freezed.dart';
part 'profile_cardiovascular.g.dart';

@freezed
class ProfileCardiovascular with _$ProfileCardiovascular{
  const factory ProfileCardiovascular({
    required int id,
    @JsonKey(name: 'SystolicPressure') double? systolicPressure,
    @JsonKey(name: 'DiastolicPressure') double? diastolicPressure,
    @JsonKey(name: 'HeartRate') double? heartFrequency,
    @JsonKey(name: 'SleepHours') double? sleepingHours,
    @JsonKey(name: 'created_by') int? createdBy,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
}) = _ProfileCardiovascular;

  const ProfileCardiovascular._();

  factory ProfileCardiovascular.fromJson(Map<String, dynamic> json) =>
      _$ProfileCardiovascularFromJson(json);
}