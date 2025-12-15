import 'package:digimed/app/domain/models/medical_specialty/medical_specialty.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor_specialist.freezed.dart';
part 'doctor_specialist.g.dart';

@freezed
class DoctorSpecialists with _$DoctorSpecialists {
  factory DoctorSpecialists({
    @JsonKey(name: 'ID') required int doctorID,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'country_code') required String countryCode,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @JsonKey(name: 'MedicalSpecialties')
    required List<MedicalSpecialty> medicalSpecialties,
  }) = _DoctorSpecialists;

  const DoctorSpecialists._();

  factory DoctorSpecialists.fromJson(Map<String, dynamic> json) =>
      _$DoctorSpecialistsFromJson(json);
}
