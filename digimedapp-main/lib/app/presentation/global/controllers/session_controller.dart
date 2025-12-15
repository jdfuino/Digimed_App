import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/presentation/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/user/user.dart';
import '../../../domain/repositories/authentication_repository.dart';
import '../state_notifier.dart';

class SessionController extends StateNotifier<User?> {
  SessionController({
    required this.authenticationRepository,
  }) : super(null);

  final AuthenticationRepository authenticationRepository;
  Doctor? doctor;
  Patients? patients;
  BuildContext? contextGlobal;

  void setUser(User user) {
    state = user;
  }

  Future<void> signOut() async {
    await authenticationRepository.signOut();
    onlyUpdate(null);
    doctor = null;
    patients = null;
  }

  void setContext(BuildContext context){
    contextGlobal = context;
  }

  void globalCloseSession() async{
     await signOut();
    if (contextGlobal != null){
      Navigator.pushReplacementNamed(
        contextGlobal!,
        Routes.login,
      );
    }
  }


}