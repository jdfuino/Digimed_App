import 'package:digimed/app/domain/models/profile_cardiovascular/profile_cardiovascular.dart';
import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_exams.freezed.dart';

part 'profile_exams.g.dart';

@freezed
class ProfileExams with _$ProfileExams {
  factory ProfileExams({
    @JsonKey(name: 'ProfileCardiovascular')
    ProfileCardiovascular? profileCardiovascular,
    @JsonKey(name: 'ProfileLaboratory')
    ProfileLaboratory? profileLaboratory
  }) = _ProfileExams;

  const ProfileExams._();

  factory ProfileExams.fromJson(Map<String, dynamic> json) =>
      _$ProfileExamsFromJson(json);
}

ProfileCardiovascular? cardioPathFromJson(Map<String, dynamic> json) {
  try{
    return ProfileCardiovascular.fromJson(
        json['Patient']['ProfileCardiovascular']?['Latest']);
  }catch(_){
    return null;
  }
}

ProfileLaboratory? labPathFromJson(Map<String, dynamic> json) {
  try{
    return ProfileLaboratory.fromJson(
        json['Patient']['ProfileLaboratory']?['Latest']);
  }
  catch(_){
    return null;
  }
}