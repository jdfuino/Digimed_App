import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_request_failure.freezed.dart';

@freezed
class HttpRequestFailure with _$HttpRequestFailure {
  factory HttpRequestFailure.notFound() = HttpRequestFailureNotFound;

  factory HttpRequestFailure.network() = HttpRequestFailureNetwork;

  factory HttpRequestFailure.emailExist() = HttpRequestFailureEmailExist;

  factory HttpRequestFailure.unauthorized() = HttpRequestFailureUnauthorized;

  factory HttpRequestFailure.tokenInvalided() =
      HttpRequestFailureTokenInvalided;

  factory HttpRequestFailure.unknown() = HttpRequestFailureUnknown;

  factory HttpRequestFailure.formData(String message,) =
      HttpRequestFailureformData;
}
