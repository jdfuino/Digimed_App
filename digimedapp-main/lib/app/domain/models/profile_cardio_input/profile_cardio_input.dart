import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_cardio_input.freezed.dart';
part 'profile_cardio_input.g.dart';

@freezed
class ProfileCardioInput with _$ProfileCardioInput{
  const factory ProfileCardioInput({
    @JsonKey(name: 'PatientID') required int patientID,
    @JsonKey(name: 'SystolicPressure') required int systolicPressure,
    @JsonKey(name: 'DiastolicPressure') required int diastolicPressure,
    @JsonKey(name: 'HeartRate') required int heartFrequency,
    @JsonKey(name: 'SleepHours') required int sleepingHours,
  }) = _ProfileCardioInput;

  const ProfileCardioInput._();

  factory ProfileCardioInput.fromJson(Map<String, dynamic> json) =>
      _$ProfileCardioInputFromJson(json);
}