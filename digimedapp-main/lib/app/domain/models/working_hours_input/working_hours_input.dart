import 'package:freezed_annotation/freezed_annotation.dart';

part 'working_hours_input.freezed.dart';
part 'working_hours_input.g.dart';

@freezed
class WorkingHoursInput with _$WorkingHoursInput {
  const factory WorkingHoursInput({
    @JsonKey(name: 'Tag')
    required String tag,
    @JsonKey(name: 'StartHour0')
    String? startTime0,
    @JsonKey(name: 'StopHour0')
    String? stopTime0,
    @JsonKey(name: 'StartHour1')
    String? startTime1,
    @JsonKey(name: 'StopHour1')
    String? stopTime1,
  }) = _WorkingHoursInput;

  const WorkingHoursInput._();

  factory WorkingHoursInput.fromJson(Map<String, dynamic> json) =>
      _$WorkingHoursInputFromJson(json);
}