import 'dart:io';

import 'package:digimed/app/domain/globals/enums_digimed.dart';
import 'package:digimed/app/domain/models/medical_history/medical_history.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/models/upload_followed_up_method_input/upload_followed_up_method_input.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/user_data_input/user_data_input.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/state/home_patient_admin_state.dart';
import 'package:digimed/app/presentation/pages/register/patient/controller/state/register_patient_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

class RegisterPatientController extends StateNotifier<RegisterPatientState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  int step;

  RegisterPatientController(super._state,
      {required this.accountRepository,
      required this.sessionController,
      required this.step});

  String? password, confirmPassword;
  TextEditingController dateCtl = TextEditingController();

  //Data User temp
  String? fullNamedTemp,
      emailTemp,
      occupationTemp,
      codeCountryTemp,
      phoneNumberTemp;
  double? weightTemp, heightTemp;
  String? urlImageProfile;
  late DateTime dateTemp;
  Patients? patientsTemp;
  File? fileTemp;
  MedicalHistory medicalHistoryTemp = const MedicalHistory();

  bool isUpload = false;
  String? birthday;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? occupation;
  double? weight;
  double? height;

  bool nexStep = false;

  Future<void> init() async {
    setDataTemp();
    await changeState();
  }

  Future<void> changeState() async {
    switch (step) {
      case 0:
        state = state.copyWith(
            registerStepPatientState:
                const RegisterStepPatientState.changePassword());
        break;
      case 1:
        state = state.copyWith(
            registerStepPatientState:
                const RegisterStepPatientState.changeData());
        break;
      case 2:
        state = state.copyWith(
            registerStepPatientState:
                const RegisterStepPatientState.changePathology());
        break;
      case 3:
        state = state.copyWith(
            registerStepPatientState:
                const RegisterStepPatientState.changeFamilyPathology());
        break;
      case 4:
        state = state.copyWith(
            registerStepPatientState:
                const RegisterStepPatientState.changeHabit());
        break;
      case 5:
        state = state.copyWith(
            registerStepPatientState:
            const RegisterStepPatientState.changeFood());
        break;
      case 6:
        state = state.copyWith(
            registerStepPatientState:
            const RegisterStepPatientState.changeEnv());
        break;
      case 7:
        state = state.copyWith(
            registerStepPatientState:
                const RegisterStepPatientState.changeFollowed());
        break;
      case 8:
        state = state.copyWith(
            registerStepPatientState:
                const RegisterStepPatientState.changeProfileImage());
        break;
      case 9:
        state = state.copyWith(
            registerStepPatientState:
                const RegisterStepPatientState.newProfileCardiovascular());
        break;
      default:
        state = state.copyWith(
            registerStepPatientState:
                const RegisterStepPatientState.changePassword());
        break;
    }
  }

  Future<void> changePassword() async {
    if (confirmPassword != null) {
      state = state.copyWith(requestState: RequestState.fetch());
      final result = await accountRepository.completeStep1Patient(
          confirmPassword!, patientsTemp!.user.id, patientsTemp!.patientID);

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
            formData: (message) {
              showToast(message);
            });
        state = state.copyWith(requestState: RequestState.normal());
      }, right: (status) async {
        state = state.copyWith(requestState: RequestState.normal());
        if (status) {
          showToast("Datos guardado correctamente.");
          print(step);
          step = 1;
          print(step);
          await changeState();
        }
      });
    }
  }

  void onVisibilityPasswordChanged(bool isVisibility) {
    state = state.copyWith(isVisiblePassword: isVisibility);
  }

  void setDataTemp() {
    patientsTemp = sessionController.patients;
    // print("control");
    // print(patientsTemp!.toJson());
    if (patientsTemp!.medicalHistory == null) {
      MedicalHistory newMedicalHistory = const MedicalHistory();
      patientsTemp = patientsTemp!.copyWith(medicalHistory: newMedicalHistory);
      print(newMedicalHistory.toJson());
    }
    dateTemp = DateTime.parse(sessionController.patients!.user.birthday);
    emailTemp = sessionController.patients!.user.email;
    codeCountryTemp = sessionController.patients!.user.countryCode;
    phoneNumberTemp = sessionController.patients!.user.phoneNumber;
    occupationTemp = sessionController.patients!.user.occupation;
    urlImageProfile = sessionController.patients!.user.urlImageProfile;
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
            DateTime.parse(sessionController.patients!.user.birthday)) ||
        emailTemp != sessionController.patients!.user.email ||
        "${codeCountryTemp}-${phoneNumberTemp}" !=
            "${sessionController.patients!.user.countryCode}-${sessionController.patients!.user.phoneNumber}" ||
        occupationTemp != sessionController.patients!.user.occupation) {
      //TODO:Subir datos
      print("Hay datos nuevos para subir");
    }
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
    } else {
      nexStep = true;
      goToNewStep(2);
    }
  }

  Future<void> setDataBasic(UserDataInput userDataInput) async {
    state = state.copyWith(requestState: RequestState.fetch());
    final result = await accountRepository.completeStep2Patient(
        userDataInput, patientsTemp!.user.id, patientsTemp!.patientID);

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
      state = state.copyWith(requestState: RequestState.normal());
      if (value) {
        resetData();
        nexStep = true;
        showToast("Datos guardado correctamente.");
        await getDataPatient(patientState: const PatientStateLoading());
      }
    });
  }

  Future<void> getDataPatient({PatientState? patientState}) async {
    if (patientState != null) {
      state = state.copyWith(patientState: patientState);
    }
    final result =
        await accountRepository.getPatientData(patientsTemp!.user.id);
    state = result.when(left: (failed) {
      return state.copyWith(patientState: PatientState.failed(failed));
    }, right: (patient) {
      patientsTemp = patient;
      sessionController.patients = patient;
      print("doctor ID: ${patient.meDoctorID}");
      return state.copyWith(patientState: PatientState.loaded(patient));
    });
  }

  void resetData() {
    isUpload = false;
    birthday = null;
    email = null;
    countryCode = null;
    phoneNumber = null;
    occupation = null;
    weight = null;
    height = null;
    medicalHistoryTemp = const MedicalHistory();
  }

  Future<void> goToNewStep(int step) async {
    final result =
        await accountRepository.goToStepPatient(step, patientsTemp!.patientID);
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
      state = state.copyWith(patientState: PatientState.failed(failed));
    }, right: (value) async {
      if (value) {}
    });
  }

  Future<void> onChangedDate(DateTime date) async {
    dateCtl.text = convertDate(date.toUtc().toString());
    dateTemp = date;
    birthday = getDateWithFormatToUpload(date);
    notifyListeners();
  }

  void formPathologyCardio(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(hasCardiovascularProblems: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(hasCardiovascularProblems: value);
    print(patientsTemp!.medicalHistory!.toJson());
    notifyListeners();
  }

  void formPathologyCancer(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory:
            patientsTemp!.medicalHistory!.copyWith(hasCancerProblems: value));
    medicalHistoryTemp = medicalHistoryTemp.copyWith(hasCancerProblems: value);
    notifyListeners();
  }

  void formPathologyDiabetic(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(hasDiabeticsProblems: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(hasDiabeticsProblems: value);
    notifyListeners();
  }

  void formPathologyObesity(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory:
            patientsTemp!.medicalHistory!.copyWith(hasObesityProblems: value));
    medicalHistoryTemp = medicalHistoryTemp.copyWith(hasObesityProblems: value);
    notifyListeners();
  }

  void formPathologyRespiratory(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(hasRespiratoryProblems: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(hasRespiratoryProblems: value);
    notifyListeners();
  }

  void formPathologyMental(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory:
            patientsTemp!.medicalHistory!.copyWith(hasMentalProblems: value));
    medicalHistoryTemp = medicalHistoryTemp.copyWith(hasMentalProblems: value);
    notifyListeners();
  }

  void formPathologyFlu(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(hasFrequentFluProblems: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(hasFrequentFluProblems: value);
    notifyListeners();
  }

  void formPathologyFamilyCardio(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(haveRelativesCardiovascularProblems: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(haveRelativesCardiovascularProblems: value);
    notifyListeners();
  }

  void formPathologyFamilyCancer(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(haveRelativesCancerProblems: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(haveRelativesCancerProblems: value);
    notifyListeners();
  }

  void formPathologyFamilyDiabetic(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(haveRelativesDiabeticsProblems: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(haveRelativesDiabeticsProblems: value);
    notifyListeners();
  }

  void formPathologyFamilyObesity(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(haveRelativesObesityProblems: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(haveRelativesObesityProblems: value);
    notifyListeners();
  }

  void formPathologyFamilyRespiratory(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(haveRelativesRespiratoryProblems: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(haveRelativesRespiratoryProblems: value);
    notifyListeners();
  }

  void formPathologyFamilyMental(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(haveRelativesMentalProblems: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(haveRelativesMentalProblems: value);
    notifyListeners();
  }

  void formHabitDrinking(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory:
            patientsTemp!.medicalHistory!.copyWith(hasDrinkingHabit: value));
    medicalHistoryTemp = medicalHistoryTemp.copyWith(hasDrinkingHabit: value);
    notifyListeners();
  }

  void formHabitSmoking(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory:
            patientsTemp!.medicalHistory!.copyWith(hasSmokingHabit: value));
    medicalHistoryTemp = medicalHistoryTemp.copyWith(hasSmokingHabit: value);
    notifyListeners();
  }

  void formHabitDrinkingCaffeine(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(hasDrinkingCaffeineHabit: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(hasDrinkingCaffeineHabit: value);
    notifyListeners();
  }

  void formHabitMedication(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory:
            patientsTemp!.medicalHistory!.copyWith(hasMedication: value));
    medicalHistoryTemp = medicalHistoryTemp.copyWith(hasMedication: value);
    notifyListeners();
  }

  void formHabitFitness(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory:
            patientsTemp!.medicalHistory!.copyWith(hasFitnessHabit: value));
    medicalHistoryTemp = medicalHistoryTemp.copyWith(hasFitnessHabit: value);
    notifyListeners();
  }

  void formHabitEating(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(hasEatingAfterHoursHabit: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(hasEatingAfterHoursHabit: value);
    notifyListeners();
  }

  void formConsumeCannedFood(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(consumeCannedFood: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(consumeCannedFood: value);
    notifyListeners();
  }

  void formConsumeSugaryFood(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(consumeSugaryFood: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(consumeSugaryFood: value);
    notifyListeners();
  }

  void formConsumeSaturedFood(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(consumeSaturedFood: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(consumeSaturedFood: value);
    notifyListeners();
  }

  void formConsumeHighlySeasonedFoods(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(consumeHighlySeasonedFoods: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(consumeHighlySeasonedFoods: value);
    notifyListeners();
  }

  void formConsumePreparedFoods(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(consumePreparedFoods: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(consumePreparedFoods: value);
    notifyListeners();
  }

  void formSatisfiedWithJob(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(satisfiedWithJob: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(satisfiedWithJob: value);
    notifyListeners();
  }

  void formHavePersonalGoals(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(havePersonalGoals: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(havePersonalGoals: value);
    notifyListeners();
  }

  void formHaveAccessEssentialService(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(haveAccessEssentialService: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(haveAccessEssentialService: value);
    notifyListeners();
  }

  void formHaveProperties(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(haveProperties: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(haveProperties: value);
    notifyListeners();
  }

  void formHaveProblemEnviromentalContamination(bool value) {
    patientsTemp = patientsTemp!.copyWith(
        medicalHistory: patientsTemp!.medicalHistory!
            .copyWith(haveProblemEnviromentalContamination: value));
    medicalHistoryTemp =
        medicalHistoryTemp.copyWith(haveProblemEnviromentalContamination: value);
    notifyListeners();
  }

  Future<void> checkDataCardio() async {
    if (medicalHistoryTemp.hasCardiovascularProblems != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.hasCancerProblems != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.hasDiabeticsProblems != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.hasObesityProblems != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.hasRespiratoryProblems != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.hasMentalProblems != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.hasRespiratoryProblems != null) {
      isUpload = true;
    }

    if (isUpload) {
      await uploadMedicalHistory();
    } else {
      nexStep = true;
      await goToNewStep(3);
    }
  }

  Future<void> checkDataFamily() async {
    if (medicalHistoryTemp.haveRelativesCardiovascularProblems != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.haveRelativesCancerProblems != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.haveRelativesDiabeticsProblems != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.haveRelativesObesityProblems != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.haveRelativesRespiratoryProblems != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.haveRelativesMentalProblems != null) {
      isUpload = true;
    }

    if (isUpload) {
      await uploadMedicalHistory();
    } else {
      nexStep = true;
      await goToNewStep(4);
    }
  }

  Future<void> checkDataHabit() async {
    if (medicalHistoryTemp.hasDrinkingHabit != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.hasSmokingHabit != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.hasDrinkingCaffeineHabit != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.hasMedication != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.hasFitnessHabit != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.hasEatingAfterHoursHabit != null) {
      isUpload = true;
    }

    if (isUpload) {
      await uploadMedicalHistory();
    } else {
      nexStep = true;
      await goToNewStep(5);
    }
  }

  Future<void> checkFoodHabit() async {
    if (medicalHistoryTemp.consumeCannedFood != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.consumeSugaryFood != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.consumeSaturedFood != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.consumeHighlySeasonedFoods != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.consumePreparedFoods != null) {
      isUpload = true;
    }

    if (isUpload) {
      await uploadMedicalHistory();
    } else {
      nexStep = true;
      await goToNewStep(6);
    }
  }

  Future<void> checkEnvHabit() async {
    if (medicalHistoryTemp.satisfiedWithJob != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.havePersonalGoals != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.haveAccessEssentialService != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.haveProperties != null) {
      isUpload = true;
    }

    if (medicalHistoryTemp.haveProblemEnviromentalContamination != null) {
      isUpload = true;
    }

    if (isUpload) {
      await uploadMedicalHistory();
    } else {
      nexStep = true;
      await goToNewStep(7);
    }
  }

  Future<void> uploadMedicalHistory() async {
    state = state.copyWith(requestState: RequestState.fetch());
    print(medicalHistoryTemp.toString());
    final result = await accountRepository.upLoadHistoricMedical(
        medicalHistoryTemp, patientsTemp!.patientID);

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
        await getDataPatient(patientState: const PatientStateLoading());
      }
    });
  }

  Future<void> uploadFollowedMethod() async {
    final input = UploadFollowedUpMethodInput(
        patientID: patientsTemp!.patientID,
        followUpMethod: patientsTemp!.followUpMethod != null
            ? patientsTemp!.followUpMethod!
            : []);
    state = state.copyWith(requestState: RequestState.fetch());
    final result = await accountRepository.upLoadFollowedMethod(input);

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
        await goToNewStep(8);
        state = state.copyWith(requestState: RequestState.normal());
        await getDataPatient(patientState: const PatientStateLoading());
      }
    });
  }

  void changeFollowed(String followUpMethodItem) {
    List<String> listTemp = [];
    listTemp = patientsTemp!.followUpMethod != null
        ? [...patientsTemp!.followUpMethod!]
        : [];
    if (followUpMethodItem != followUpMethod[4]) {
      if (listTemp.contains(followUpMethodItem)) {
        listTemp.remove(followUpMethodItem);
      } else {
        listTemp.add(followUpMethodItem);
      }
      listTemp.remove(followUpMethod[4]);
      patientsTemp = patientsTemp!.copyWith(followUpMethod: listTemp);
      notifyListeners();
    } else {
      print("passs");
      listTemp = [];
      listTemp.add(followUpMethodItem);
      patientsTemp = patientsTemp!.copyWith(followUpMethod: listTemp);
      notifyListeners();
    }
  }

  Future<void> checkFileData() async {
    if (fileTemp != null) {
      print("Subir arcivo");
      state = state.copyWith(requestState: RequestState.fetch());
      final result =
          await accountRepository.uploadImage(fileTemp!, patientsTemp!.user.id);
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
      }, right: (_) async {
        nexStep = true;
        final result = await goToNewStep(7);
        state = state.copyWith(requestState: RequestState.normal());
      });
    } else {
      nexStep = true;
      final result = await goToNewStep(7);
    }
  }
}
