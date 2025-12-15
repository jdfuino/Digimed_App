import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
class Activity with _$Activity {
  factory Activity({
    @JsonKey(name: 'Name')
    required String name,
    @JsonKey(name: 'PatientPoints')
    required int patientPoints,
    @JsonKey(name: 'DoctorPoints')
    required int doctorPoints,
    @JsonKey(name: 'CreatedAt') required String createdAt}) =_Activity;

  const Activity._();

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}