import 'package:freezed_annotation/freezed_annotation.dart';

part 'assessment_input.freezed.dart';
part 'assessment_input.g.dart';

@freezed
class AssessmentInput with _$AssessmentInput {
  const factory AssessmentInput({
    @JsonKey(name: 'name') required String fullName,
    @JsonKey(name: 'gender') required String gender,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'objective') required String objective,
    @JsonKey(name: 'subjective') required String subjective,
  }) = _AssessmentInput;

  const AssessmentInput._();

  factory AssessmentInput.fromJson(Map<String, dynamic> json) =>
      _$AssessmentInputFromJson(json);
}