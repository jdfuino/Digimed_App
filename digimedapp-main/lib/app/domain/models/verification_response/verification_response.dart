import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_response.freezed.dart';
part 'verification_response.g.dart';

@freezed
class VerificationResponse with _$VerificationResponse {
  const factory VerificationResponse({
    @JsonKey(name: 'treatment') required String treatment,
    @JsonKey(name: 'is_requerid_recipe') required bool isRequiredRecipe,
    @JsonKey(name: 'is_create_treatment') required bool isCreateTreatment,
  }) = _VerificationResponse;

  factory VerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$VerificationResponseFromJson(json);
}