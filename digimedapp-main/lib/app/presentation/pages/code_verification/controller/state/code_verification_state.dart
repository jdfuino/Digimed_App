import 'package:freezed_annotation/freezed_annotation.dart';

part 'code_verification_state.freezed.dart';

@freezed
class CodeVerificationState with _$CodeVerificationState {
  factory CodeVerificationState({
    @Default('') String code,
    @Default(false) bool visibility,
    @Default(false) bool fetching,
  }) = _CodeVerificationState;
}
