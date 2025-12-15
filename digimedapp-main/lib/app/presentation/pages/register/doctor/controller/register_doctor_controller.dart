import 'dart:io';

import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/user_data_input/user_data_input.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:digimed/app/presentation/pages/register/doctor/controller/state/register_doctor_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

class RegisterDoctorController extends StateNotifier<RegisterDoctorState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  int step;

  RegisterDoctorController(super._state,
      {required this.accountRepository,
      required this.sessionController,
      required this.step});

  String? password, confirmPassword;
  TextEditingController dateCtl = TextEditingController();
  Doctor? doctor;
  bool isFetch = false;

  //Data User temp
  late String fullNamedTemp,
      emailTemp,
      occupationTemp,
      codeCountryTemp,
      phoneNumberTemp;
  String? urlImageProfile;
  File? fileTemp;
  late DateTime dateTemp;

  bool isUpload = false;
  bool nexStep = false;

  String? birthday;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? occupation;

  Future<void> init() async {
    doctor = state.doctorData.when(
        loading: () => null,
        faild: (_) => null,
        sucess: (doctor) {
          return doctor;
        });
    changeState();
    setDataTemp();
  }

  Future<void> getDataDoctor({DoctorData? doctorData}) async {
    if (doctorData != null) {
      state = state.copyWith(doctorData: doctorData);
    }
    if (doctor != null) {
      final result = await accountRepository.getDoctorData(doctor!.user.id);
      state = result.when(left: (failed) {
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
        return state.copyWith(doctorData: DoctorData.faild(failed));
      }, right: (doctorData) {
        sessionController.doctor = doctorData;
        doctor = doctorData;
        return state.copyWith(
            doctorData: DoctorData.sucess(doctor: doctorData));
      });
    }
  }

  Future<void> refreshDataDoctor() async {
    if (doctor != null) {
      final result = await accountRepository.getDoctorData(doctor!.user.id);
      result.when(left: (failed) {
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
      }, right: (doctorData) {
        sessionController.doctor = doctorData;
        doctor = doctorData;
      });
    }
  }

  Future<void> changeState() async {
    switch (step) {
      case 0:
        state = state.copyWith(
            registerStepDoctorState:
                const RegisterStepDoctorState.changePassword());
        break;
      case 1:
        state = state.copyWith(
            registerStepDoctorState:
                const RegisterStepDoctorState.changeData());
        break;
      case 2:
        state = state.copyWith(
            registerStepDoctorState:
                const RegisterStepDoctorState.changeProfileImage());
        break;
      default:
        state = state.copyWith(
            registerStepDoctorState:
            const RegisterStepDoctorState.changePassword());
        break;
    }
  }

  void onVisibilityPasswordChanged(bool isVisibility) {
    state = state.copyWith(isVisiblePassword: isVisibility);
  }

  void setDataTemp() {
    dateTemp = DateTime.parse(doctor!.user.birthday);
    emailTemp = doctor!.user.email;
    codeCountryTemp = doctor!.user.countryCode;
    phoneNumberTemp = doctor!.user.phoneNumber;
    occupationTemp = doctor!.user.occupation;
    urlImageProfile = doctor!.user.urlImageProfile;
  }

  bool isDateIsEqual(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day) {
      return true;
    }
    return false;
  }

  Future<void> checkDataForUpgrade() async {
    if (!isDateIsEqual(dateTemp,
            DateTime.parse(sessionController.doctor!.user.birthday)) ||
        emailTemp != sessionController.doctor!.user.email ||
        "${codeCountryTemp}-${phoneNumberTemp}" !=
            "${sessionController.doctor!.user.countryCode}-${sessionController.doctor!.user.phoneNumber}" ||
        occupationTemp != sessionController.doctor!.user.occupation) {
      //TODO:Subir datos
      print("Hay datos nuevos para subir");
    }
  }

  Future<void> onChangedDate(DateTime date) async {
    dateCtl.text = convertDate(date.toUtc().toString());
    dateTemp = date;
    birthday = getDateWithFormatToUpload(date);
    notifyListeners();
  }

  Future<void> checkData() async {
    UserDataInput userDataInput = const UserDataInput();

    if (birthday != null) {
      userDataInput = userDataInput.copyWith(birthday: birthday);
      isUpload = true;
    }

    if (email != null) {
      userDataInput = userDataInput.copyWith(email: email);
      isUpload = true;
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
      await setDataBasic(userDataInput);
    } else {
      nexStep = true;
      await goToNewStep(2);
    }
  }

  Future<void> goToNewStep(int step) async {
    final result = await accountRepository.goToStepDoctor(
        doctor!.user.id, step, doctor!.idDoctor);
    result.when(left: (failed) {
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
      state = state.copyWith(doctorData: DoctorData.faild(failed));
    }, right: (value) async {
      if (value) {
      }
    });
  }

  Future<void> setDataBasic(UserDataInput userDataInput) async {
    state = state.copyWith(requestState: RequestState.fetch());
    final result = await accountRepository.completeStep2Doctor(
        userDataInput, doctor!.user.id, doctor!.idDoctor);
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
      state = state.copyWith(requestState: RequestState.normal());
    }, right: (value) async {
      if (value) {
        resetData();
        showToast("Datos guardado correctamente.");
        nexStep = true;
        state = state.copyWith(requestState: RequestState.normal());
        await getDataDoctor(doctorData: const DoctorDataLoading());
      }
    });
  }

  Future<void> changePassword() async {
    if (confirmPassword != null) {
      state = state.copyWith(requestState: RequestState.fetch());
      final result = await accountRepository.completeStep1Doctor(
          confirmPassword!, doctor!.user.id, doctor!.idDoctor);

      result.when(left: (failed) {
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
        state = state.copyWith(requestState: RequestState.normal());
      }, right: (status) async{
        state = state.copyWith(requestState: RequestState.normal());
        if (status) {
          showToast("Datos guardado correctamente.");
          step = 1;
          await changeState();
        }
      });
    }
  }

  void resetData() {
    isUpload = false;
    birthday = null;
    email = null;
    countryCode = null;
    phoneNumber = null;
    occupation = null;
  }

  Future<void> checkFileData() async {
    if(!isFetch){
      if (fileTemp != null) {
        print("Subir arcivo");
        isFetch = true;
        final result =
        await accountRepository.uploadImage(fileTemp!, doctor!.user.id);
        result.when(left:  (failed) {
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
          isFetch = false;
        }, right: (_) async{
          final result = await goToNewStep(3);
          await refreshDataDoctor();
          isFetch = false;
        });
      }else{
        final result = await goToNewStep(3);
      }
    }else{
      showToast("Estamos procesando su petición...");
    }
  }
}
