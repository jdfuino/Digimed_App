import 'package:digimed/app/data/http/http.dart';
import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/failures/login_failure/login_failure.dart';
import 'package:digimed/app/domain/models/user/user.dart';

abstract class AuthenticationRepository {
  Future<bool> get isSignedIn;
  Future<void> signOut();
  Future<Either<LoginFailure, User>> signIn(
    String username,
    String password,
  );

  Future<Either<HttpRequestFailure, bool>> recoveryPassword(
    String confirmPassword,
    String email,
    String otpCode,
  );

  Future<Either<HttpRequestFailure, bool>> recoveryPasswordEmailVerification(
    String requestEmail,
  );

  Future<Either<HttpRequestFailure, User>> recoveryPasswordCodeVerification(
    String code,
  );

  Future<Either<LoginFailure, User>> signInWithBiometric();

  Future<bool> getBiometricCredential();
}
