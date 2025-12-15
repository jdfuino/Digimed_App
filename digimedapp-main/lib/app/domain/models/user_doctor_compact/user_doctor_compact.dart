import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_doctor_compact.freezed.dart';

part 'user_doctor_compact.g.dart';

@freezed
class UserDoctorCompact with _$UserDoctorCompact {
  factory UserDoctorCompact({
    required int id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'identification_type') required String identificationType,
    @Default("") String gender,
    @JsonKey(name: 'identification_number')
    required String identificationNumber,
    @JsonKey(name: 'profile_img_url') required String? urlImageProfile,
  }) = _UserDoctorCompact;

  const UserDoctorCompact._();

  factory UserDoctorCompact.fromJson(Map<String, dynamic> json) =>
      _$UserDoctorCompactFromJson(json);
}
