import 'dart:io';

import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/globals/utils_extencion.dart';
import 'package:digimed/app/domain/models/user_input/user_input.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/failures/failures_form/failure_form.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_patient/controller/state/form_new_patient_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

class FormNewPatientController extends StateNotifier<FormNewPatientState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  final int doctorId;

  FormNewPatientController(super.state, {required this.accountRepository,
  required this.doctorId, required this.sessionController});

  TextEditingController dateCtl = TextEditingController();

  //Personal Data Temp
  File? file;
  String? genderTemp;
  late String fullName;
  late String identificationType;
  late String identificationNumber;
  late DateTime dateTemp;
  late String email;
  late String countryCode;
  String? phoneNumber;
  late String occupation;
  double? weightTemp;
  double? heightTemp;
  late String datePatient;

  Future<void> onChangedDate(DateTime date) async {
    dateCtl.text = convertDate(date.toUtc().toString());
    datePatient = getDateWithFormatToUpload(date);
    print(datePatient);
    notifyListeners();
  }

  Future<void> onChangedGender(String gender) async {
    genderTemp = gender;
    state = state.copyWith(gender: gender);
  }

  Future<void> onChangedImage(String url) async {
    state = state.copyWith(imgProfile: url);
  }

  Future<Either<HttpRequestFailure, bool>> checkedData() async {
    Either<HttpRequestFailure, bool> either;
    if (genderTemp == null) {
      either = Either.left(HttpRequestFailure.formData("Selecciona un genero"));
      return Future.value(either);
    } else if (phoneNumber == null ||
        phoneNumber!.isEmpty ||
        !phoneNumber!.isValidIdNumber()) {
      either = Either.left(HttpRequestFailure.
      formData("Agregue un numero de telefono valido"));
      return Future.value(either);
    }
    state = state.copyWith(requestState: const RequestStateFetch());
    final userInput = UserInput(
        fullName: fullName,
        email: email,
        password: "123456789",
        gender: genderTemp!,
        identificationType: identificationType,
        identificationNumber: identificationNumber,
        countryCode: countryCode,
        phoneNumber: phoneNumber!,
        occupation: occupation,
        birthday: datePatient,
      weight: weightTemp,
      height: heightTemp
    );
    final result = await accountRepository.registerPatient(userInput, doctorId,file);
    state = state.copyWith(requestState: const RequestStateNormal());
    return result;
  }
}
