import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_working_hours.freezed.dart';
part 'item_working_hours.g.dart';

@freezed
class ItemWorkingHours with _$ItemWorkingHours {
  const factory ItemWorkingHours({
    @JsonKey(name: 'StartHour')
    required String startTime,
    @JsonKey(name: 'StopHour')
    required String stopTime,
  }) = _ItemWorkingHours;

  const ItemWorkingHours._();

  factory ItemWorkingHours.fromJson(Map<String, dynamic> json) =>
      _$ItemWorkingHoursFromJson(json);
}