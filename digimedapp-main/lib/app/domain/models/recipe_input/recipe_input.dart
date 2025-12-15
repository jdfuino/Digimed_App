import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_input.freezed.dart';
part 'recipe_input.g.dart';

@freezed
class RecipeInput with _$RecipeInput {
  const factory RecipeInput({
    @JsonKey(name: 'name') required String fullName,
    @JsonKey(name: 'patientID') required String patientID,
    @JsonKey(name: 'patientIDInt') required int patientCI,
    @JsonKey(name: 'age') required int age,
    @JsonKey(name: 'treatment') required String plan,
    @JsonKey(name: 'title') required String title,
  }) = _RecipeInput;

  const RecipeInput._();

  factory RecipeInput.fromJson(Map<String, dynamic> json) =>
      _$RecipeInputFromJson(json);
}