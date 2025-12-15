import 'package:digimed/app/domain/models/medical_center/medical_center.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor.freezed.dart';
part 'doctor.g.dart';

@freezed
class Doctor with _$Doctor {
   factory Doctor({
     @JsonKey(name: 'ID')
     required int idDoctor,
     @JsonKey(name: 'User')
     required User user,
     @JsonKey(name: 'RegisterStep')
     int? registerStep,
     @JsonKey(name: 'SignedContract')
     bool? contract,
     @JsonKey(name: 'TotalScore')
     int? totalScore,
     @JsonKey(name: 'WorkingHour') List<WorkingHours>? hours,
     @JsonKey(name: 'MedicalCenters') List<MedicalCenter>? medicalCenters,
   }) =_Doctors;

   const Doctor._();

   factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);
}
