import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/user_data_input/user_data_input.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:digimed/app/presentation/pages/info_doctor/doctor/controller/state/info_doctor_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InfoDoctorController extends StateNotifier<InfoDoctorState> {
  final AccountRepository accountRepository;
  final AuthenticationRepository authenticationRepository;
  final int fatherId;
  final SessionController sessionController;

  InfoDoctorController(super._state,
      {required this.accountRepository,
      required this.fatherId,
      required this.authenticationRepository,
      required this.sessionController});

  late User userTemp;
  late int doctorId;
  bool isUpload = false;
  String? birthday;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? occupation;
  TextEditingController dateCtl = TextEditingController();

  bool isSession = false;

  Future<void> init() async {
    userTemp = sessionController.doctor!.user;
  }

  Future<void> getDataDoctor({MyDoctorDataState? myDoctorDataState}) async {
    if (myDoctorDataState != null) {
      state = state.copyWith(myDoctorDataState: myDoctorDataState);
    }
    // esto devuelve al usuario a la pagina de login.
    if (isSession == true) {
      sessionController.globalCloseSession();
    }
    final result = await accountRepository.getDoctorData(fatherId);
    state = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () {
            showToast("Sesion expirada");
            sessionController.globalCloseSession();
          },
          orElse: () {});
      return state.copyWith(myDoctorDataState: MyDoctorDataState.faild(failed));
    }, right: (doctor) {
      userTemp = doctor.user;
      doctorId = doctor.idDoctor;
      sessionController.doctor = doctor;
      return state.copyWith(
          myDoctorDataState:
              MyDoctorDataState.sucess(user: doctor.user, list: doctor.hours));
    });
  }

  void settingChanged() async {
    state = state.copyWith(isSetting: !state.isSetting);
  }

  Future<void> onChangedDate(DateTime date) async {
    dateCtl.text = DateFormat('yyyy/MM/dd').format(date);
    birthday = getDateWithFormatToUpload(date);
    notifyListeners();
  }

  void checkData() async {
    UserDataInput userDataInput = const UserDataInput();

    if (birthday != null) {
      userDataInput = userDataInput.copyWith(birthday: birthday);
      isUpload = true;
    }

    if (email != null) {
      userDataInput = userDataInput.copyWith(email: email);
      isUpload = true;
      isSession = true;
    }

    if (countryCode != null) {
      userDataInput = userDataInput.copyWith(countryCode: countryCode);
      isUpload = true;
    }

    if (phoneNumber != null) {
      userDataInput = userDataInput.copyWith(phoneNumber: phoneNumber);
      isUpload = true;
    }

    if (occupation != null) {
      userDataInput = userDataInput.copyWith(occupation: occupation);
      isUpload = true;
    }

    if (isUpload) {
      print(userDataInput.toJson());
      await setDataBasic(userDataInput);
    }
    settingChanged();
  }

  Future<void> setDataBasic(UserDataInput userDataInput) async {
    state = state.copyWith(requestState: const RequestStateFetch());
    final result =
        await accountRepository.setDataBasic(userDataInput, userTemp.id);
    await result.when(left: (failed) {
      failed.when(
          notFound: () => showToast("Datos no encontrado"),
          network: () => showToast("No hay conexion con Internet"),
          unauthorized: () =>
              showToast("No estas autorizado para realizar esta accion"),
          tokenInvalided: () {
            showToast("Sesion expirada");
            sessionController.globalCloseSession();
          },
          unknown: () => showToast("Hemos tenido un problema"),
          emailExist: () => showToast("Email ya registrado"),
          formData: (String message) {
            showToast(message);
          });
      state = state.copyWith(requestState: const RequestStateNormal());
    }, right: (value) async {
      if (value) {
        resetData();
        showToast("Datos guardado correctamente.");
        state = state.copyWith(requestState: const RequestStateNormal());
        await getDataDoctor(
            myDoctorDataState: const MyDoctorDataState.loading());
      }
    });
  }

  void resetData() {
    isUpload = false;
    birthday = null;
    email = null;
    countryCode = null;
    phoneNumber = null;
    occupation = null;
  }
}
