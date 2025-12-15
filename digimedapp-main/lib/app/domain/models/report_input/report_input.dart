import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_input.freezed.dart';
part 'report_input.g.dart';

@freezed
class ReportInput with _$ReportInput {
  const factory ReportInput({
    @JsonKey(name: 'name') required String fullName,
    @JsonKey(name: 'id') required String numberID,
    @JsonKey(name: 'patientId') required int patientID,
    @JsonKey(name: 'gender') required String gender,
    @JsonKey(name: 'age') required int age,
    @JsonKey(name: 'mail') required String email,
    @JsonKey(name: 'treatment') required String plan,
    @JsonKey(name: 'diagnostic') required String assessment,
    @JsonKey(name: 'doctor') required String doctorName,
    @JsonKey(name: 'title') required String token,
  }) = _ReportInput;

  const ReportInput._();

  factory ReportInput.fromJson(Map<String, dynamic> json) =>
      _$ReportInputFromJson(json);
}