import 'package:freezed_annotation/freezed_annotation.dart';

part 'input_soap.freezed.dart';
part 'input_soap.g.dart';

@freezed
class InputSOAP with _$InputSOAP{
  const factory InputSOAP({
    @JsonKey(name: 'PatientID')
    required int patientID,
    @JsonKey(name: 'SubjectiveNote')
    String? subjectiveNote,
    @JsonKey(name: 'ObjectiveNote')
    String? objectiveNote,
    @JsonKey(name: 'AssessmentNote')
    String? assessmentNote,
    @JsonKey(name: 'PlanNote')
    String? planNote,
  }) = _InputSOAP;

  const InputSOAP._();

  factory InputSOAP.fromJson(Map<String, dynamic> json) => _$InputSOAPFromJson(json);
}