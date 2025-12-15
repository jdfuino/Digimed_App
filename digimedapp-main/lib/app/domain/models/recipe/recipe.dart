import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    @JsonKey(name: 'id') required int reportID,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'recipe') required String recipe,
    @JsonKey(name: 'createdAt') required String createdAt
  }) = _Recipe;

  const Recipe._();

  factory Recipe.fromJson(Map<String, dynamic> json) =>
      _$RecipeFromJson(json);
}