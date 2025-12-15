import 'package:digimed/app/data/providers/local/session_service.dart';
import 'package:digimed/app/data/providers/remote/account_api.dart';
import 'package:digimed/app/data/providers/remote/authentication_api.dart';
import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/failures/login_failure/login_failure.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  AuthenticationRepositoryImplementation(
    this._authenticationAPI,
    this._accountAPI,
    this._sessionService,
  );

  final AuthenticationAPI _authenticationAPI;
  final AccountAPI _accountAPI;
  final SessionService _sessionService;

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _sessionService.sessionId;
    return sessionId != null;
  }

  @override
  Future<Either<LoginFailure, User>> signIn(
      String username, String password) async {
    final requesResult =
        await _authenticationAPI.login(email: username, password: password);

    return requesResult.when(
        left: (failure) => Either.left(failure),
        right: (token) async {
          await _sessionService.saveSessionId(token);
          await _sessionService.saveCredentials(username, password);
          final user = await _accountAPI.getAccount(token);

          if (user == null) {
            return Either.left(
              LoginFailure.unknown(),
            );
          }

          return Either.right(user);
        });
  }

  @override
  Future<void> signOut() {
    return _sessionService.signOut();
  }

  @override
  Future<Either<HttpRequestFailure, bool>> recoveryPassword(
      String confirmPassword, String email, String otpCode) async {
    return await _authenticationAPI.passwordVerification(
      confirmPassword: confirmPassword,
      email: email,
      otpCode: otpCode,
    );
  }

  @override
  Future<Either<HttpRequestFailure, bool>> recoveryPasswordEmailVerification(
      String requestEmail) async {
    return await _authenticationAPI.emailVerification(
        requestEmail: requestEmail);
  }

  @override
  Future<Either<HttpRequestFailure, User>> recoveryPasswordCodeVerification(
      String code) async {
    return await _authenticationAPI.codePasswordVerification(code: code);
  }

  @override
  Future<Either<LoginFailure, User>> signInWithBiometric() async {
    final credentials = await _sessionService.credentials;

    if (credentials.username == null || credentials.password == null) {
      return Left(LoginFailure.notFound());
    }

    final requestResult = await _authenticationAPI.login(
      email: credentials.username!,
      password: credentials.password!,
    );

    return requestResult.when(
        left: (failure) => Either.left(failure),
        right: (token) async {
          await _sessionService.saveSessionId(token);
          final user = await _accountAPI.getAccount(token);

          if (user == null) {
            return Either.left(
              LoginFailure.unknown(),
            );
          }

          return Either.right(user);
        });
  }

  @override
  Future<bool> getBiometricCredential() async {
    final credentials = await _sessionService.credentials;

    if (credentials.username == null || credentials.password == null) {
      return false;
    } else {
      return true;
    }
  }
}
