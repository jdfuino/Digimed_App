import 'package:digimed/app/domain/models/profile_cardiovascular/profile_cardiovascular.dart';
import 'package:digimed/app/domain/models/profile_exams/profile_exams.dart';
import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:digimed/app/domain/models/user_doctor_compact/user_doctor_compact.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_home.freezed.dart';

part 'patient_home.g.dart';

@freezed
class PatientHome with _$PatientHome {
  factory PatientHome({
    @JsonKey(name: 'User') required UserDoctorCompact user,
    @JsonKey(name: 'ProfileCardiovascular')
    ProfileCardiovascular? profileCardiovascular,
    @JsonKey(name: 'ProfileLaboratory')
    ProfileLaboratory? profileLaboratory
    }) = _PatientHome;

  const PatientHome._();

  factory PatientHome.fromJson(Map<String, dynamic> json) =>
      _$PatientHomeFromJson(json);
}


