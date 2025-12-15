import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_input.freezed.dart';
part 'plan_input.g.dart';

@freezed
class PlanInput with _$PlanInput {
  const factory PlanInput({
    @JsonKey(name: 'name') required String fullName,
    @JsonKey(name: 'gender') required String gender,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'objective') required String objective,
    @JsonKey(name: 'subjective') required String subjective,
    @JsonKey(name: 'Diagnostico') required String assessment,
  }) = _PlanInput;

  const PlanInput._();

  factory PlanInput.fromJson(Map<String, dynamic> json) =>
      _$PlanInputFromJson(json);
}