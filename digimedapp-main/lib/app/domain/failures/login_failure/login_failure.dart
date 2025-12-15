import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_failure.freezed.dart';

@freezed
class LoginFailure with _$LoginFailure {
  factory LoginFailure.notFound() = LoginFailureNotFound;
  factory LoginFailure.notVerified() = LoginFailureNotVerified;
  factory LoginFailure.network() = LoginFailureNetwork;
  factory LoginFailure.unauthorized() = LoginFailureUnauthorized;
  factory LoginFailure.unknown() = LoginFailureUnknown;
}