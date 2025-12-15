import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String username,
    @Default('') String password,
    @Default(false) bool visibility,
    @Default(true) bool inputVisibles,
    @Default(false) bool fetching,
    @Default(false) bool hasCredentials
  }) = _LoginState;
} // aqui en el inputVisible
