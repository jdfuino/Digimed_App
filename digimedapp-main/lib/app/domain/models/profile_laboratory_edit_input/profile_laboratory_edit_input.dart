import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_laboratory_edit_input.freezed.dart';
part 'profile_laboratory_edit_input.g.dart';

@freezed
class ProfileLaboratoryEditInput with _$ProfileLaboratoryEditInput {
  const factory ProfileLaboratoryEditInput({
    @JsonKey(name: 'Glucose') required double glucose,
    @JsonKey(name: 'Triglycerides') required double triglycerides,
    @JsonKey(name: 'Cholesterol') required double cholesterol,
    @JsonKey(name: 'Hemoglobin') required double hemoglobin,
    @JsonKey(name: 'UricAcid')  double? uricAcid,
  }) = _ProfileLaboratoryEditInput;

  const ProfileLaboratoryEditInput._();

  factory ProfileLaboratoryEditInput.fromJson(Map<String, dynamic> json) =>
      _$ProfileLaboratoryEditInputFromJson(json);
}