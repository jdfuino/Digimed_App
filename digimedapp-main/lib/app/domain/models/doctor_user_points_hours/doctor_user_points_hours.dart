import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor_user_points_hours.freezed.dart';

part 'doctor_user_points_hours.g.dart';

@freezed
class DoctorUserPointsHours with _$DoctorUserPointsHours {
  factory DoctorUserPointsHours({
    @JsonKey(name: 'ID')  required int idDoctor,
    @JsonKey(name: 'User') required User user,
    @JsonKey(name: 'TotalScore') required int totalScore,
    @JsonKey(name: 'WorkingHour') List<WorkingHours>? hours
  }) = _DoctorUserPointsHours;

  const DoctorUserPointsHours._();

  factory DoctorUserPointsHours.fromJson(Map<String, dynamic> json) =>
      _$DoctorUserPointsHoursFromJson(json);
}
