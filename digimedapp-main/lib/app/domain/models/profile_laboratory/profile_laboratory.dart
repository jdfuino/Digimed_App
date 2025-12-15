import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_laboratory.freezed.dart';

part 'profile_laboratory.g.dart';

@freezed
class ProfileLaboratory with _$ProfileLaboratory {
  const factory ProfileLaboratory({
    required int id,
    @JsonKey(name: 'Glucose') required double glucose,
    @JsonKey(name: 'Triglycerides') required double triglycerides,
    @JsonKey(name: 'Cholesterol') required double cholesterol,
    @JsonKey(name: 'Hemoglobin') required double hemoglobin,
    @JsonKey(name: 'UricAcid') required double? uricAcid,
    @JsonKey(name: 'created_by') int? createdBy,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
  }) = _ProfileLaboratory;

  const ProfileLaboratory._();

  factory ProfileLaboratory.fromJson(Map<String, dynamic> json) =>
      _$ProfileLaboratoryFromJson(json);
}
