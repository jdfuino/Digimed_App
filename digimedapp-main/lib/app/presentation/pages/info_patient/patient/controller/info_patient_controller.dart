import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/medical_history/medical_history.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/user_data_input/user_data_input.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/controller/state/info_patient_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InfoPatientController extends StateNotifier<InfoPatientState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  final AuthenticationRepository authenticationRepository;
  Patients patients;

  InfoPatientController(super.state,
      {required this.accountRepository,
      required this.sessionController,
      required this.patients,
      required this.authenticationRepository});

  late Patients tempPatient;
  Patients? patientsTemp;
  TextEditingController dateCtl = TextEditingController();

  //Habit Data Temp
  Map<String, bool?> habitDataTemp = {
    "0": null,
    "1": null,
    "2": null,
    "3": null,
    "4": null,
    "5": null,
  };

  late DateTime dateTemp;
  late String emailTemp;
  late String codeCountryTemp;
  late String phoneNumberTemp;
  late String occupationTemp;
  late double? weightTemp;
  late double? heightTemp;

  late User userTemp;
  late int patientId;
  bool isUpload = false;
  String? birthday;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? occupation;
  double? weight;
  double? height;

  bool isSession = false;

  Future<void> init() async {
    tempPatient = patients;
    await setData(patients);
    await getMeDoctor();
  }

  Future<void> refreshMePatient({
    DataPatientState? associatePatientPatients,
  }) async {
    if (associatePatientPatients != null) {
      state = state.copyWith(dataPatientState: associatePatientPatients);
    }
    // esto devuelve al usuario a la pagina de login.
    if (isSession == true) {
      sessionController.globalCloseSession();
    }
    final result = await accountRepository.getMePatient(patients.user);
    state = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () {
            showToast("Sesion expirada");
            sessionController.globalCloseSession();
          },
          orElse: () {});
      return state.copyWith(dataPatientState: const DataPatientState.failed());
    }, right: (newPatient) {
      sessionController.patients = newPatient;
      if (newPatient != null) {
        userTemp = patients.user;
        patientId = patients.patientID;
        // newPatient = patients;
        setData(newPatient);
        sessionController.setUser(newPatient.user);
      }
      return state.copyWith(
          dataPatientState: DataPatientState.loaded(newPatient));
    });
  }

  Future<void> getMeDoctor({DataDoctorState? dataDoctorState}) async {
    if (dataDoctorState != null) {
      state = state.copyWith(dataDoctorState: dataDoctorState);
    }
    final result = await accountRepository.getMyDoctorData(patients.user.id);
    state = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () {
            showToast("Sesion expirada");
            sessionController.globalCloseSession();
          },
          orElse: () {});
      return state.copyWith(dataDoctorState: const DataDoctorState.failed());
    }, right: (doctor) {
      return state.copyWith(dataDoctorState: DataDoctorState.loaded(doctor));
    });
  }

  Future<void> setDataBasic(UserDataInput userDataInput) async {
    state = state.copyWith(requestState: const RequestStateFetch());
    final result =
        await accountRepository.setDataBasic(userDataInput, patients.user.id);
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
        await refreshMePatient();
      }
    });
  }

  void changedSettingState() {
    state = state.copyWith(isSetting: !state.isSetting);
  }

  void changedSettingStateInformationPatient() {
    state = state.copyWith(isSettingDataBasic: !state.isSettingDataBasic);
    notifyListeners();
  }

  Future<void> setData(Patients newPatient) async {
    print("set Patient");
    print(newPatient.medicalHistory!.toJson());
    tempPatient = newPatient;
    //Habit Data Temp
    habitDataTemp["0"] = newPatient.medicalHistory!.hasDrinkingHabit;
    habitDataTemp["1"] = newPatient.medicalHistory!.hasSmokingHabit;
    habitDataTemp["2"] = newPatient.medicalHistory!.hasDrinkingCaffeineHabit;
    habitDataTemp["3"] = newPatient.medicalHistory!.hasMedication;
    habitDataTemp["4"] = newPatient.medicalHistory!.hasFitnessHabit;
    habitDataTemp["5"] = newPatient.medicalHistory!.hasEatingAfterHoursHabit;
  }

  bool _checkNull(Map<String, bool?> myMap) {
    for (bool? value in myMap.values) {
      if (value == null) {
        return false;
      }
    }
    return true;
  }

  Future<Either<HttpRequestFailure, bool>> checkHabitData() async {
    Either<HttpRequestFailure, bool> either;
    if (!_checkNull(habitDataTemp)) {
      return either = Either.left(HttpRequestFailure.formData(
          "Por favor complete los datos faltantes"));
    }
    MedicalHistory medicalHistoryInput = const MedicalHistory();
    medicalHistoryInput =
        medicalHistoryInput.copyWith(hasDrinkingHabit: habitDataTemp["0"]);
    medicalHistoryInput =
        medicalHistoryInput.copyWith(hasSmokingHabit: habitDataTemp["1"]);
    medicalHistoryInput = medicalHistoryInput.copyWith(
        hasDrinkingCaffeineHabit: habitDataTemp["2"]);
    medicalHistoryInput =
        medicalHistoryInput.copyWith(hasMedication: habitDataTemp["3"]);
    medicalHistoryInput =
        medicalHistoryInput.copyWith(hasFitnessHabit: habitDataTemp["4"]);
    medicalHistoryInput = medicalHistoryInput.copyWith(
        hasEatingAfterHoursHabit: habitDataTemp["5"]);
    print(medicalHistoryInput.toJson());
    final result = await accountRepository.upLoadHistoricMedical(
        medicalHistoryInput, tempPatient.patientID);

    return result;
  }

  void onChangedDatePathology(String key, bool newValue) {
    if (habitDataTemp[key] != newValue) {
      print(newValue);
      habitDataTemp[key] = newValue;
      notifyListeners();
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

    if (weight != null) {
      userDataInput = userDataInput.copyWith(weight: weight);
      isUpload = true;
    }

    if (height != null) {
      userDataInput = userDataInput.copyWith(height: height);
      isUpload = true;
    }

    if (isUpload) {
      await setDataBasic(userDataInput);
    }
    state = state.copyWith(isSettingDataBasic: false);
  }
}
