import 'package:digimed/app/domain/models/last_soap/last_soap.dart';
import 'package:digimed/app/domain/models/medical_history/medical_history.dart';
import 'package:digimed/app/domain/models/profile_cardiovascular/profile_cardiovascular.dart';
import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:digimed/app/domain/models/treatment/treatment.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'patients.freezed.dart';
part 'patients.g.dart';

@freezed
class Patients with _$Patients{
  factory Patients({
    @JsonKey(name: 'ID')
    required int patientID,
    required User user,
    @JsonKey(name: 'TotalScore')
    int? totalScore,
    MedicalHistory? medicalHistory,
    ProfileLaboratory? profileLaboratory,
    @JsonKey(name: 'SignedContract')
    bool? signedContract,
    @JsonKey(name: 'RegisterStep')
    int? registerStep,
    @JsonKey(name: 'FollowUpMethod')
    List<String>? followUpMethod,
    int? meDoctorID,
    String? doctorPhoneNumber,
    String? doctorCountryCode,
    @Default([])
    List<Treatment> treatments,
    @JsonKey(name: 'LatestSOAPNote')
    LastSOAP? lastSoap,
    ProfileCardiovascular? profileCardiovascular}) =_Patients;

  const Patients._();

  factory Patients.fromJson(Map<String, dynamic> json) => _$PatientsFromJson(json);
}