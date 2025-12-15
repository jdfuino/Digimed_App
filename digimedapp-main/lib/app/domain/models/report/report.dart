import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';

@freezed
class Report with _$Report {
  const factory Report({
    @JsonKey(name: 'id') required int reportID,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'report') required String html,
    @JsonKey(name: 'createdAt') required String createdAt
  }) = _Report;

  const Report._();

  factory Report.fromJson(Map<String, dynamic> json) =>
      _$ReportFromJson(json);
}