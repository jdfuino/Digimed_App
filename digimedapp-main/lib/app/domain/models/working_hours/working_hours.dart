import 'package:freezed_annotation/freezed_annotation.dart';

part 'working_hours.freezed.dart';
part 'working_hours.g.dart';

@freezed
class WorkingHours with _$WorkingHours {
  const factory WorkingHours({
    @JsonKey(name: 'Tag')
    required String tag,
    @JsonKey(name: 'DayOfWeek')
    required int dayOfWeek,
    @JsonKey(name: 'StartHour0')
    String? startTime0,
    @JsonKey(name: 'StopHour0')
    String? stopTime0,
    @JsonKey(name: 'StartHour1')
    String? startTime1,
    @JsonKey(name: 'StopHour1')
    String? stopTime1,
  }) = _WorkingHours;

  const WorkingHours._();

  factory WorkingHours.fromJson(Map<String, dynamic> json) =>
      _$WorkingHoursFromJson(json);
}
