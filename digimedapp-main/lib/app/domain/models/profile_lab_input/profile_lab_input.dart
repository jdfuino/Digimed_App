import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_lab_input.freezed.dart';

part 'profile_lab_input.g.dart';

@freezed
class ProfileLabInput with _$ProfileLabInput {
  const factory ProfileLabInput({
    @JsonKey(name: 'PatientID') required int patientID,
    @JsonKey(name: 'Glucose') required double glucose,
    @JsonKey(name: 'Triglycerides') required double triglycerides,
    @JsonKey(name: 'Cholesterol') required double cholesterol,
    @JsonKey(name: 'Hemoglobin') required double hemoglobin,
    @JsonKey(name: 'UricAcid')  double? uricAcid,
  }) = _ProfileLabInput;

  const ProfileLabInput._();

  factory ProfileLabInput.fromJson(Map<String, dynamic> json) =>
      _$ProfileLabInputFromJson(json);
}
