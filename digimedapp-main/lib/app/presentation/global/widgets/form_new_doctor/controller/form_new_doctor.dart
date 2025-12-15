import 'dart:io';

import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/user_input/user_input.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormNewDoctorController extends StateNotifier<FormNewDoctorState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;

  FormNewDoctorController(super.state, {
    required this.accountRepository,
    required this.sessionController
  });

  TextEditingController dateCtl = TextEditingController();
  File? file;
  late String
      fullName,
      identificationType,
      identificationNumber,
      email,
      countryCode,
      phoneNumber,
      occupation;
  late String dateDoctor;
  String? genderDoctor;

  Future<void> onChangedDate(DateTime date) async {
    dateCtl.text = DateFormat('yyyy/MM/dd').format(date);
    dateDoctor = getDateWithFormatToUpload(date);
    print(dateDoctor);
    state = state.copyWith(dateTime: date);
  }

  void onChangedName(String text) {
    onlyUpdate(
      state.copyWith(fullName: text),
    );
  }

  void onChangedIdNumber(String text) {
    onlyUpdate(
      state.copyWith(idNumber: text),
    );
  }

  void onChangedEmail(String text) {
    onlyUpdate(
      state.copyWith(email: text),
    );
  }

  void onChangedPhone(String text) {
    onlyUpdate(
      state.copyWith(phoneNumber: text),
    );
  }

  void onChangedOccupation(String text) {
    onlyUpdate(
      state.copyWith(occupation: text),
    );
  }

  Future<void> onChangedGender(String gender) async {
    genderDoctor = gender;
    state = state.copyWith(gender: gender);
  }

  Future<void> onChangedImage(String url) async {
    state = state.copyWith(imgProfile: url);
  }

  Future<Either<HttpRequestFailure, bool>> registerDoctor() async {
    Either<HttpRequestFailure, bool> either;
    if(genderDoctor == null){
      either = Either.left(HttpRequestFailure.formData("Selecciona un genero"));
      return Future.value(either);
    }
    state = state.copyWith(requestState: const RequestStateFetch());
    final userInput = UserInput(
        fullName: fullName,
        email: email,
        password: "123456789",
        gender: genderDoctor!,
        identificationType: identificationType,
        identificationNumber: identificationNumber,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        occupation: occupation,
        birthday: dateDoctor);
    final data = await accountRepository.registerDoctor(userInput,file);
    state = state.copyWith(requestState: const RequestStateNormal());
    return data;
  }

  void disposedSheet() {
    dateCtl.text = '';
    file = null;
    onlyUpdate(state.copyWith(
        gender: null,
        fullName: null,
        idNumber: null,
        dateTime: null,
        email: null,
        phoneNumber: null,
        occupation: null,
        imgProfile: null));
  }
}
