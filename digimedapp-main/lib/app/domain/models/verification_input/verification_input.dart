import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_input.freezed.dart';

part 'verification_input.g.dart';

@freezed
class VerificationInput with _$VerificationInput {
  const factory VerificationInput({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'number_id') required String numberID,
    @JsonKey(name: 'patientId') required int patientId,
    @JsonKey(name: 'gender') required String gender,
    @JsonKey(name: 'age') required int age,
    @JsonKey(name: 'mail') required String mail,
    @JsonKey(name: 'treatment') required String treatment,
    @JsonKey(name: 'doctor') required String doctor,
    @JsonKey(name: 'doctor_id') required int doctorId,
    String? token,
  }) = _VerificationInput;

  factory VerificationInput.fromJson(Map<String, dynamic> json) =>
      _$VerificationInputFromJson(json);
}
