part of 'http.dart';

class HttpFailure {
  HttpFailure({
    this.statusCode,
    this.exception,
    this.errorGraphQlDigimed,
    this.data,
  });

  final int? statusCode;
  final String? errorGraphQlDigimed;
  final Object? exception;
  final Object? data;
}

//class NetworkException {}