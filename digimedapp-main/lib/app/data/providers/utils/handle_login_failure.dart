import 'package:digimed/app/data/http/http.dart';
import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/login_failure/login_failure.dart';

Either<LoginFailure, R> handleHttpLoginFailure<R>(HttpFailure httpFailure) {
  final failure = () {
    final error = httpFailure.errorGraphQlDigimed;
    print("###################### Error #################################");
    print(error);
    switch (error) {
      case "Incorrect Email or Password...":
        return LoginFailure.unauthorized();
    }
    print("###################### Exception #################################");
    print(httpFailure.exception);
    if (httpFailure.exception == "network") {
      return LoginFailure.network();
    }
    return LoginFailure.unknown();
  }();
  return Either.left(failure);
}