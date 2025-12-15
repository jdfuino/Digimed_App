import 'package:digimed/app/data/http/grapgh_ql_digimed.dart';
import 'package:digimed/app/data/http/http.dart';
import 'package:digimed/app/data/providers/data_test/data_test.dart';
import 'package:digimed/app/data/providers/utils/handle_failure.dart';
import 'package:digimed/app/data/providers/utils/handle_login_failure.dart';
import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/failures/login_failure/login_failure.dart';
import 'package:digimed/app/domain/models/user/user.dart';

class AuthenticationAPI {
  AuthenticationAPI(this._http, this._graphQLDigimed);

  final Http _http;
  final GraphQLDigimed _graphQLDigimed;

  Future<Either<LoginFailure, String>> login(
      {required String email, required String password}) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (response) {
        print(response);
        final json = response as Map;
        return json["login"]["Token"];
      },
      body: '''query Login(\$email: String!, \$password: String!) {
    login(email: \$email, password: \$password) {
      Token
      Role
    }
  }''',
      variables: {'email': email, 'password': password},
    );

    return result.when(
        left: handleHttpLoginFailure,
        right: (newRequestToken) {
          _graphQLDigimed.refreshToken(newRequestToken);
          return Either.right(newRequestToken);
        });
  }

  Future<Either<HttpRequestFailure, bool>> emailVerification({
    required String requestEmail,
  }) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (response) {
        print(response);
        final jsonBool = response['resetPasswordRequest'] as bool;
        if (jsonBool) {
          return true;
        }
        return false;
      },
      method: GraphQLMethod.mutation,
      body: '''
      mutation resetPasswordRequest(\$email: String!){
        resetPasswordRequest(email: \$email)
      }
      ''',
      variables: {'email': requestEmail},
    );
    return result.when(
      left: handleHttpFailure,
      right: (data) => Either.right(data),
    );
  }

  Future<Either<HttpRequestFailure, User>> codePasswordVerification({
    required String code,
  }) async {
    final User user = User.fromJson(
        userFake); // funcion para convertir un json en objeto.(sin modelo)
    return Future.value(Either.right(user));
  }

  Future<Either<HttpRequestFailure, bool>> passwordVerification({
    required String confirmPassword,
    required String email,
    required String otpCode,
  }) async {
    print(email);
    print(otpCode);
    print(confirmPassword);
    final result = await _graphQLDigimed.request(
      onSuccess: (response) {
        print(response);
        final jsonBool = response['resetPasswordConfirmation'] as bool;
        if (jsonBool) {
          return true;
        }
        return false;
      },
      method: GraphQLMethod.mutation,
      body: '''
      mutation resetPasswordConfirmation(\$email: String!, \$otpCode: String!, \$password: String!){
        resetPasswordConfirmation(email: \$email, otpCode: \$otpCode, password: \$password)
      }
      ''',
      variables: {
        'email': email,
        'otpCode': otpCode,
        'password': confirmPassword,
      },
    );
    return result.when(
      left: handleHttpFailure,
      right: (data) => Either.right(data),
    );
  }
}
