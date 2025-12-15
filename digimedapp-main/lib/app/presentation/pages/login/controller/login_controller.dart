import 'dart:io';

import 'package:digimed/app/data/providers/local/local_auth.dart';
import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/failures/login_failure/login_failure.dart';
import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';
import 'package:digimed/app/domain/repositories/fcm_repository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/login/controller/state/login_state.dart';
import 'package:flutter/material.dart';

class LoginController extends StateNotifier<LoginState> {
  final AuthenticationRepository authenticationRepository;
  final SessionController sessionController;
  final AccountRepository accountRepository;
  final FCMRepository fcmRepository;

  LoginController(super.state,
      {required this.authenticationRepository,
      required this.sessionController,
      required this.fcmRepository,
      required this.accountRepository});

  Future<void> init() async {
    await checkCredentials();
    offVisibilityInputs(state.hasCredentials);
  }

  void onUsernameChanged(String text) {
    onlyUpdate(
      state.copyWith(
        username: text.trim().toLowerCase(),
      ),
    );
  }

  void onPasswordChanged(String text) {
    onlyUpdate(
      state.copyWith(
        password: text.replaceAll(' ', ''),
      ),
    );
  }

  Future<void> checkCredentials() async {
    state = state.copyWith(
        hasCredentials:
            await authenticationRepository.getBiometricCredential());
  }

  void onVisibilityChanged(bool isVisibility) {
    state = state.copyWith(visibility: isVisibility);
  }

// usar este para mostrar los inputs
  void onVisibilityInputs() {
    state = state.copyWith(inputVisibles: false);
  }

  void offVisibilityInputs(hasCredentials) {
    if (hasCredentials == false) {
      state = state.copyWith(inputVisibles: false);
    } else {
      state = state.copyWith(inputVisibles: true);
    }
  }

  Future<Either<LoginFailure, User>> submit() async {
    state = state.copyWith(fetching: true);
    final result = await authenticationRepository.signIn(
      state.username,
      state.password,
    );

    result.when(
      left: (_) => state = state.copyWith(fetching: false),
      right: (user) {
        sessionController.setUser(user);
      },
    );

    return result;
  }

  Future<Either<LoginFailure, User>> submitWithBiometric() async {
    state = state.copyWith(fetching: true);
    final authen = await LocalAuth.authenticate();
    if (!authen) {
      logger.e('Biometric authentication failed');
      state = state.copyWith(fetching: false);
      return Left(LoginFailure.unknown());
    }
    state = state.copyWith(fetching: true);
    final result = await authenticationRepository.signInWithBiometric();

    result.when(
      left: (_) => state = state.copyWith(fetching: false),
      right: (user) {
        sessionController.setUser(user);
      },
    );

    return result;
  }

  Future<Either<HttpRequestFailure, Doctor>> getMeDoctor(User user) async {
    state = state.copyWith(fetching: true);
    final result = await accountRepository.getMeDoctor(user);

    result.when(
      left: (_) => state = state.copyWith(fetching: false),
      right: (doctor) {
        sessionController.doctor = doctor;
      },
    );

    return result;
  }

  Future<Either<HttpRequestFailure, Patients?>> getMePatients(User user) async {
    state = state.copyWith(fetching: true);
    final result = await accountRepository.getMePatient(user);

    result.when(
      left: (_) => state = state.copyWith(fetching: false),
      right: (patient) {
        sessionController.patients = patient;
      },
    );

    return result;
  }
}
