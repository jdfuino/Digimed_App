import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_specialty.freezed.dart';

part 'medical_specialty.g.dart';

@freezed
class MedicalSpecialty with _$MedicalSpecialty {
  const factory MedicalSpecialty({
    @JsonKey(name: 'ID') required int specialtyID,
    @JsonKey(name: 'Name') required String name,
    @JsonKey(name: 'Description') String? description,
  }) = _MedicalSpecialty;

  const MedicalSpecialty._();

  factory MedicalSpecialty.fromJson(Map<String, dynamic> json) =>
      _$MedicalSpecialtyFromJson(json);
}
