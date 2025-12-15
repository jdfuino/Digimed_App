import 'package:digimed/app/data/http/http.dart';
import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../domain/globals/logger.dart';

Either<HttpRequestFailure, R> handleHttpFailure<R>(HttpFailure httpFailure) {
  final failure = () {
    final error = httpFailure.errorGraphQlDigimed;
    logger.e(error);
    switch (error) {
      case "Invalid or expired JWT":
        return HttpRequestFailure.tokenInvalided();
      case "Email already exists on database...":
        return HttpRequestFailure.emailExist();
      case "Requested data not found...":
        return HttpRequestFailure.notFound();
      case "The requested source data not found.":
        return HttpRequestFailure.notFound();
      case "Action denied for false attribution.":
        return HttpRequestFailure.unauthorized();
    }
    logger.e(httpFailure.exception);
    if (httpFailure.exception == "network") {
      return HttpRequestFailure.network();
    }
    else if(httpFailure.exception == "time out"){
      return HttpRequestFailure.formData("Tiempo de espera superado.");
    }
    else if(error.toString().contains('duplicate key value violates unique constraint')){
      return HttpRequestFailure.formData("El numero de cedula ya esta registrado.");
    }
    return HttpRequestFailure.formData(error ?? "Hemos tenido un problema");
  }();
  return Either.left(failure);
}
//ERROR: duplicate key value violates unique constraint "users_identification_number_key" (SQLSTATE 23505)