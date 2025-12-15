import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_restore_password_state.freezed.dart';

@freezed
class RequestPasswordState with _$RequestPasswordState {
  factory RequestPasswordState({
    @Default('') String requestEmail,
    @Default(false) bool visibility,
    @Default(false) bool fetching,
  }) = _RequestPasswordState;
}
