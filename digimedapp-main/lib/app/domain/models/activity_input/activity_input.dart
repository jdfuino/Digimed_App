import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_input.freezed.dart';
part 'activity_input.g.dart';

@freezed
class ActivityInput with _$ActivityInput{
  const factory ActivityInput({
    @JsonKey(name: 'Name') required String name,
    @JsonKey(name: 'RoleID') required int roleID,
    @JsonKey(name: 'DoctorPoints') required int doctorPoints,
    @JsonKey(name: 'PatientPoints') required int patientPoints,
  }) = _ActivityInput;

  const ActivityInput._();

  factory ActivityInput.fromJson(Map<String, dynamic> json) =>
      _$ActivityInputFromJson(json);
}