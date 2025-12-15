import 'package:local_auth/local_auth.dart';

import '../../../domain/globals/logger.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();
  static Future<bool> _canAuth() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (!await _canAuth()){
        logger.e("El dispositivo no soporta autenticación biométrica");
        return false;
      }
      return await _auth.authenticate(
        localizedReason: "Confirma tu identidad para continuar",
        options: const AuthenticationOptions(
          biometricOnly: true,
          // stickyAuth: true,
          // useErrorDialogs: true,
        ),
      );
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
  }
}

  // static Future<Either<LoginFailure, User>> authenticate(
  //     AuthenticationRepository _authenticationRepository) async {
  //   try {
  //     if (!await _canAuth()) return Left(LoginFailure.unknown());
  //     final bool didAuthenticate = await _auth.authenticate(
  //       localizedReason: "Confirma tu identidad para continuar",
  //       options: const AuthenticationOptions(biometricOnly: true),
  //     );

  //     if (didAuthenticate) {
  //       return await _authenticationRepository.signInWithBiometric("", "");
  //     } else {
  //       return Left(LoginFailure.unknown());
  //     }
  //   } catch (e) {
  //     return Left(LoginFailure.unknown());
  //   }
  // }
