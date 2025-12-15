import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_followed_up_method_input.freezed.dart';

part 'upload_followed_up_method_input.g.dart';

@freezed
class UploadFollowedUpMethodInput with _$UploadFollowedUpMethodInput {
  const factory UploadFollowedUpMethodInput({
    @JsonKey(name: 'PatientID') required int patientID,
    @JsonKey(name: 'FollowUpMethod') required List<String> followUpMethod,
  }) = _UploadFollowedUpMethodInput;

  const UploadFollowedUpMethodInput._();

  factory UploadFollowedUpMethodInput.fromJson(Map<String, dynamic> json) =>
      _$UploadFollowedUpMethodInputFromJson(json);
}
