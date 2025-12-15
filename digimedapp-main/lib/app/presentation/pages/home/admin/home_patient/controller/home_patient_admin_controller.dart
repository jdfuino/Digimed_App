import 'dart:ffi';

import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/globals/enums_digimed.dart';
import 'package:digimed/app/domain/models/assessment_input/assessment_input.dart';
import 'package:digimed/app/domain/models/doctor_specialist/doctor_specialist.dart';
import 'package:digimed/app/domain/models/input_soap/input_soap.dart';
import 'package:digimed/app/domain/models/medical_history/medical_history.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/models/plan_input/plan_input.dart';
import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:digimed/app/domain/models/profile_laboratory_edit_input/profile_laboratory_edit_input.dart';
import 'package:digimed/app/domain/models/recipe_input/recipe_input.dart';
import 'package:digimed/app/domain/models/report_input/report_input.dart';
import 'package:digimed/app/domain/models/upload_followed_up_method_input/upload_followed_up_method_input.dart';
import 'package:digimed/app/domain/models/user_data_input/user_data_input.dart';
import 'package:digimed/app/domain/models/verification_input/verification_input.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/state/home_patient_admin_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePatientAdminController extends StateNotifier<HomePatientAdminState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  final int userID;
  final int patientId;
  Patients fatherPatient;

  // final DoctorSpecialists doctorSpecialists;

  HomePatientAdminController(super._state,
      {required this.accountRepository,
      required this.userID,
      required this.sessionController,
      required this.patientId,
      required this.fatherPatient});

  late Patients patients;
  Patients? patientsTemp;
  TextEditingController dateCtl = TextEditingController();
  List<DoctorSpecialists> listD = [];

  //Personal Data Temp
  late DateTime dateTemp;
  late String emailTemp;
  late String codeCountryTemp;
  late String phoneNumberTemp;
  late String occupationTemp;
  late double? weightTemp;
  late double? heightTemp;

  bool isUpload = false;
  String? birthday;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? occupation;
  double? weight;
  double? height;

  //Pathology Data Temp
  Map<String, bool?> pathologyDataTemp = {
    "cardioTemp": null,
    "cancerTemp": null,
    "diabeticTemp": null,
    "obesyTemp": null,
    "respTemp": null,
    "mentalTemp": null,
    "fluxTemp": null
  };

  bool? hasCardio;
  bool? hasCancer;
  bool? hasDiabetic;
  bool? hasObesity;
  bool? hasResp;
  bool? hasMental;
  bool? hasFlux;

  //family Data Temp
  Map<String, bool?> familyDataTemp = {
    "0": null,
    "1": null,
    "2": null,
    "3": null,
    "4": null,
    "5": null,
  };

  bool? haveCardio;
  bool? haveCancer;
  bool? haveDiabetic;
  bool? haveObesity;
  bool? haveResp;
  bool? haveMental;

  //Habit Data Temp
  Map<String, bool?> habitDataTemp = {
    "0": null,
    "1": null,
    "2": null,
    "3": null,
    "4": null,
    "5": null,
  };

  bool? hasDrink;
  bool? hasSmoking;
  bool? hasCaffe;
  bool? hasMedication;
  bool? hasFit;
  bool? hasEat;

  //Note SOAP
  String? noteS;
  String? dateS; //= "2023-04-05T14:55:45.556Z";
  String? noteO;
  String? dateO;
  String? noteA;
  String? dateA;
  String? noteP;
  String? dateP;

  //Algorithm 1
  String? healthSummary;
  String? historyAnalysis;

  //Algorithm 2
  String? assessmentIA;
  String? planIA;

  bool? edit;

  Future<void> init() async {
    await getDataPatient();
    await getResultsLabs();
    await loadListDoctorsSpecialist();
    await loadReports();
    await loadRecipe();
  }

  Future<void> updateResultLab(
      {ResultLabState? resultLabState,
      required int idResultLab,
      required ProfileLaboratoryEditInput profileLaboratory}) async {
    if (resultLabState != null) {
      state = state.copyWith(resultLabState: resultLabState);
    }
    final result = await accountRepository.updateResultsLabs(
        profileLaboratory, idResultLab);
    result.when(
      left: (failure) {
        failure.when(
            notFound: () => showToast("Datos no encontrado"),
            network: () => showToast("No hay conexion con Internet"),
            unauthorized: () =>
                showToast("No estas autorizado para realizar esta accion"),
            tokenInvalided: () {
              showToast("Sesion expirada");
              sessionController.globalCloseSession();
            },
            unknown: () => showToast("Hemos tenido un problema"),
            emailExist: () => showToast("Email no existe"),
            formData: (String message) {
              showToast(message);
            });
        state = state.copyWith(resultLabState: ResultLabState.failed(failure));
      },
      right: (data) async {
        if (data != null) {
          showToast("Resultado de laboratorio actualizado");
          await getResultsLabs();
        } else {
          showToast("No se pudo actualizar el resultado de laboratorio");
          state = state.copyWith(
              resultLabState: ResultLabState.failed(
                  HttpRequestFailure.formData("Hemos tenido un problema")));
        }
      },
    );
  }

  Future<void> loadReports({ReportFetchState? reportFetchState}) async {
    if (reportFetchState != null) {
      state = state.copyWith(reportFetchState: reportFetchState);
    }

    final result =
        await accountRepository.getReportsByPatientID(patientId, "HALF_YEAR");

    state = result.when(
      left: (failure) {
        failure.when(
            notFound: () => showToast("Datos no encontrado"),
            network: () => showToast("No hay conexion con Internet"),
            unauthorized: () =>
                showToast("No estas autorizado para realizar esta accion"),
            tokenInvalided: () {
              showToast("Sesion expirada");
              sessionController.globalCloseSession();
            },
            unknown: () => showToast("Hemos tenido un problema"),
            emailExist: () => showToast("Email no existe"),
            formData: (String message) {
              showToast(message);
            });
        return state.copyWith(
            reportFetchState: const ReportFetchState.loaded([]));
      },
      right: (list) {
        return state.copyWith(reportFetchState: ReportFetchState.loaded(list));
      },
    );
  }

  Future<void> loadRecipe({RecipeFetchState? recipeFetchState}) async {
    if (recipeFetchState != null) {
      state = state.copyWith(recipeFetchState: recipeFetchState);
    }

    final result = await accountRepository.getPrescriptionByPatientID(
        patients.patientID, "HALF_YEAR");

    state = result.when(
      left: (failure) {
        failure.when(
            notFound: () => showToast("Datos no encontrado"),
            network: () => showToast("No hay conexion con Internet"),
            unauthorized: () =>
                showToast("No estas autorizado para realizar esta accion"),
            tokenInvalided: () {
              showToast("Sesion expirada");
              sessionController.globalCloseSession();
            },
            unknown: () => showToast("Hemos tenido un problema"),
            emailExist: () => showToast("Email no existe"),
            formData: (String message) {
              showToast(message);
            });
        return state.copyWith(
            recipeFetchState: const RecipeFetchState.loaded([]));
      },
      right: (list) {
        // listP = list;
        return state.copyWith(recipeFetchState: RecipeFetchState.loaded(list));
      },
    );
  }

  Future<void> getReportBase64(
      {ReportFetchState? reportFetchState,
      required int reportID,
      required VoidCallback onComplete}) async {
    if (reportFetchState != null) {
      state = state.copyWith(reportFetchState: reportFetchState);
    }
    final result = await accountRepository.getReportBase64(reportID);

    result.when(
      left: (failure) {
        failure.when(
            notFound: () => showToast("Datos no encontrado"),
            network: () => showToast("No hay conexion con Internet"),
            unauthorized: () =>
                showToast("No estas autorizado para realizar esta accion"),
            tokenInvalided: () {
              showToast("Sesion expirada");
              sessionController.globalCloseSession();
            },
            unknown: () => showToast("Hemos tenido un problema"),
            emailExist: () => showToast("Email no existe"),
            formData: (String message) {
              showToast(message);
            });
      },
      right: (data) async {
        var result = await createAndSavePdfFromBase64(
            base64String: data, patientName: patients.user.fullName);
        if (result) {
          onComplete();
        }
      },
    );
  }

  Future<void> getRecipeBase64(
      {ReportFetchState? reportFetchState, required int reportID}) async {
    if (reportFetchState != null) {
      state = state.copyWith(reportFetchState: reportFetchState);
    }
    final result = await accountRepository.getRecipeBase64(reportID);

    result.when(
      left: (failure) {
        failure.when(
            notFound: () => showToast("Datos no encontrado"),
            network: () => showToast("No hay conexion con Internet"),
            unauthorized: () =>
                showToast("No estas autorizado para realizar esta accion"),
            tokenInvalided: () {
              showToast("Sesion expirada");
              sessionController.globalCloseSession();
            },
            unknown: () => showToast("Hemos tenido un problema"),
            emailExist: () => showToast("Email no existe"),
            formData: (String message) {
              showToast(message);
            });
      },
      right: (data) {
        createAndSavePdfFromBase64(
            base64String: data, patientName: patients.user.fullName);
      },
    );
  }

  Future<void> loadListDoctorsSpecialist(
      {AssociateDoctorSpecialist? associateDoctorSpecialist}) async {
    if (associateDoctorSpecialist != null) {
      state =
          state.copyWith(associateDoctorSpecialist: associateDoctorSpecialist);
    }

    final result = await accountRepository.doctorSpecialitsPatient(patientId);

    state = result.when(
      left: (failure) {
        failure.when(
            notFound: () => showToast("Datos no encontrado"),
            network: () => showToast("No hay conexion con Internet"),
            unauthorized: () =>
                showToast("No estas autorizado para realizar esta accion"),
            tokenInvalided: () {
              showToast("Sesion expirada");
              sessionController.globalCloseSession();
            },
            unknown: () => showToast("Hemos tenido un problema"),
            emailExist: () => showToast("Email no existe"),
            formData: (String message) {
              showToast(message);
            });
        return state.copyWith(
            associateDoctorSpecialist:
                AssociateDoctorSpecialist.failed(failure));
      },
      right: (list) {
        listD = list;
        return state.copyWith(
            associateDoctorSpecialist: AssociateDoctorSpecialist.loaded(list));
      },
    );
  }

  Future<void> searchOnChanged(String text) async {
    state = state.copyWith(
        associateDoctorSpecialist: const AssociateDoctorSpecialist.loading());
    List<DoctorSpecialists> displayList = listD
        .where((element) =>
            element.fullName.toLowerCase().contains(text.toLowerCase()) ||
            element.medicalSpecialties.contains(text.toLowerCase()))
        .toList();

    state = state.copyWith(
        associateDoctorSpecialist:
            AssociateDoctorSpecialist.loaded(displayList));
  }

  Future<void> getResultsLabs({ResultLabState? resultLabState}) async {
    if (resultLabState != null) {
      state = state.copyWith(resultLabState: resultLabState);
    }
    final result = await accountRepository.getResultsLabs(
        fatherPatient.patientID, rangeGraph["6 meses"]!);
    state = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () {
            sessionController.globalCloseSession();
          },
          orElse: () {});
      return state.copyWith(resultLabState: ResultLabState.failed(failed));
    }, right: (list) {
      return state.copyWith(resultLabState: ResultLabState.loaded(list));
    });
  }

  Future<void> getDataPatient({PatientState? patientState}) async {
    if (patientState != null) {
      state = state.copyWith(patientState: patientState);
    }
    final result = await accountRepository.getPatientData(userID);
    state = await result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () {
            sessionController.globalCloseSession();
          },
          orElse: () {});
      return state.copyWith(patientState: PatientState.failed(failed));
    }, right: (patient) async {
      patients = patient;
      patientsTemp = patient;
      _setMyDataTemp();
      print("%%%%%%%%%%%%%%%%%%%%%%%%%");
      print(patient);
      return state.copyWith(patientState: PatientState.loaded(patient));
    });
  }

  Future<void> getHealthSummary(VoidCallback onComplete) async {
    state = state.copyWith(requestState: const RequestStateFetch());
    final result = await accountRepository.healthSummary(patients.patientID);
    healthSummary = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () {
            sessionController.globalCloseSession();
          },
          orElse: () {});
      state = state.copyWith(requestState: const RequestStateNormal());
      return null;
    }, right: (message) {
      print("HealthSummary: $message");
      state = state.copyWith(requestState: const RequestStateNormal());
      onComplete();
      return message;
    });
  }

  Future<void> getHistoryAnalysis(VoidCallback onComplete) async {
    state = state.copyWith(requestState: const RequestStateFetch());
    final result = await accountRepository
        .getPatientMedicalHistoryAnalysis(patients.patientID);
    historyAnalysis = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () {
            sessionController.globalCloseSession();
          },
          orElse: () {});
      state = state.copyWith(requestState: const RequestStateNormal());
      return null;
    }, right: (message) {
      print("HistoryAnalysis: $message");
      state = state.copyWith(requestState: const RequestStateNormal());
      onComplete();
      return message;
    });
  }

  Future<void> getAssessmentAnalysis(
      VoidCallback onComplete, Function(String) onError) async {
    state = state.copyWith(requestState: const RequestStateFetch());
    if (historyAnalysis != null &&
        healthSummary != null &&
        historyAnalysis!.isNotEmpty &&
        healthSummary!.isNotEmpty) {
      final assessmentNote = AssessmentInput(
          fullName: patients.user.fullName,
          gender: patients.user.gender,
          email: patients.user.email,
          objective: healthSummary!,
          subjective: historyAnalysis!);

      final result = await accountRepository.getIAAssessment(assessmentNote);
      assessmentIA = result.when(left: (failed) {
        failed.maybeWhen(tokenInvalided: () {
          sessionController.globalCloseSession();
        }, formData: (message) {
          onError(message);
        }, orElse: () {
          onError("Error desconocido.");
        });
        state = state.copyWith(requestState: const RequestStateNormal());
        return null;
      }, right: (message) {
        print("HistoryAnalysis: $message");
        state = state.copyWith(requestState: const RequestStateNormal());
        onComplete();
        return message;
      });
    } else {
      print("vacio los o y s");
      onError(
          "Para usar la IA debe agregar un registro de riesgo subjetivo y objetivo.");
      state = state.copyWith(requestState: const RequestStateNormal());
    }
  }

  Future<void> gePlanAnalysis(
      VoidCallback onComplete, Function(String) onError) async {
    state = state.copyWith(requestState: const RequestStateFetch());
    if (assessmentIA != null &&
        assessmentIA!.isNotEmpty &&
        historyAnalysis != null &&
        healthSummary != null &&
        historyAnalysis!.isNotEmpty &&
        healthSummary!.isNotEmpty) {
      final textPlanePlan = parseHtmlToPlainText(assessmentIA);
      final planNote = PlanInput(
          fullName: patients.user.fullName,
          gender: patients.user.gender,
          email: patients.user.email,
          objective: healthSummary!,
          subjective: historyAnalysis!,
          assessment: textPlanePlan ?? "");

      final result = await accountRepository.getIAPlan(planNote);
      planIA = result.when(left: (failed) {
        failed.maybeWhen(tokenInvalided: () {
          sessionController.globalCloseSession();
        }, formData: (message) {
          onError(message);
        }, orElse: () {
          onError("Error desconocido.");
        });
        state = state.copyWith(requestState: const RequestStateNormal());
        return null;
      }, right: (message) {
        print("HistoryAnalysis: $message");
        state = state.copyWith(requestState: const RequestStateNormal());
        onComplete();
        return message;
      });
    } else {
      state = state.copyWith(requestState: const RequestStateNormal());
      onError("Para usar la IA debe agregar un registro de diagnóstico.");
    }
  }

  Future<void> createNewReport(
      Function(String) onError, VoidCallback onComplete) async {
    state = state.copyWith(requestState: const RequestStateFetch());
    if (assessmentIA != null &&
        assessmentIA!.isNotEmpty &&
        planIA != null &&
        planIA!.isNotEmpty) {
      final reportInput = ReportInput(
          fullName: patients.user.fullName,
          numberID: patients.user.identificationNumber,
          patientID: patients.patientID,
          gender: patients.user.gender,
          age: calculateYearsFromUtcDate(patients.user.birthday),
          email: patients.user.email,
          plan: planIA!,
          assessment: assessmentIA!,
          token: patients.user.fullName,
          doctorName: "Dr ${sessionController.doctor!.user.fullName}");

      final result = await accountRepository.createReport(reportInput);
      result.when(left: (failed) {
        failed.maybeWhen(tokenInvalided: () {
          sessionController.globalCloseSession();
        }, formData: (message) {
          onError(message);
        }, orElse: () {
          onError("Error desconocido.");
        });
        state = state.copyWith(requestState: const RequestStateNormal());
      }, right: (response) {
        loadReports();
        notifyListeners();
        state = state.copyWith(requestState: const RequestStateNormal());
        onComplete();
      });
    } else {
      state = state.copyWith(requestState: const RequestStateNormal());
      onError(
          "Para usar la IA debe agregar un registro de plan de tratamiento.");
    }
  }

  Future<void> verificationCreateNewRecipe(
      Function(String) onError, VoidCallback onComplete) async {
    state = state.copyWith(requestState: const RequestStateFetch());
    if (planIA != null && planIA!.isNotEmpty) {
      final verificationInput = VerificationInput(
          name: patients.user.fullName,
          numberID: patients.user.identificationNumber,
          patientId: patients.patientID,
          gender: patients.user.gender,
          age: calculateYearsFromUtcDate(patients.user.birthday),
          mail: patients.user.email,
          treatment: planIA!,
          doctorId: sessionController.doctor!.idDoctor,
          doctor: "Dr ${sessionController.doctor!.user.fullName}");

      final result =
          await accountRepository.getTreatmentVerification(verificationInput);
      result.when(left: (failed) {
        failed.maybeWhen(tokenInvalided: () {
          sessionController.globalCloseSession();
        }, formData: (message) {
          onError(message);
        }, orElse: () {
          onError("Error desconocido.");
        });
        state = state.copyWith(requestState: const RequestStateNormal());
      }, right: (response) async {
        if (response.isRequiredRecipe) {
          final createRecipeResponse =
              await createNewRecipe(response.treatment);
          if (!createRecipeResponse) {
            onError("Error desconocido.");
          } else {
            loadRecipe();
            notifyListeners();
            if (response.isCreateTreatment) {
              onComplete();
            } else {
              onError(
                  "El tratamiento del paciente no pudo ser creado, revisa la información del plan de tratamiento.");
            }
          }
        } else {
          onError(response.treatment);
        }
        state = state.copyWith(requestState: const RequestStateNormal());
      });
    } else {
      state = state.copyWith(requestState: const RequestStateNormal());
      onError(
          "Para usar la IA debe agregar un registro de plan de tratamiento.");
    }
  }

  Future<bool> createNewRecipe(String treatment) async {
    final reportInput = RecipeInput(
      fullName: patients.user.fullName,
      patientCI: patients.patientID,
      patientID: patients.user.identificationNumber,
      age: calculateYearsFromUtcDate(patients.user.birthday),
      plan: treatment,
      title: patients.user.fullName,
    );
    final result = await accountRepository.createPrescription(reportInput);

    return result.when(left: (error) {
      return false;
    }, right: (data) {
      return true;
    });
  }

  void _setMyDataTemp() {
    dateTemp = DateTime.parse(patients.user.birthday);
    emailTemp = patients.user.email;
    codeCountryTemp = patients.user.countryCode;
    phoneNumberTemp = patients.user.phoneNumber;
    occupationTemp = patients.user.occupation;
    weightTemp = patients.user.weight;
    heightTemp = patients.user.height;

    if (patients.medicalHistory != null) {
      //Pathology Temp
      pathologyDataTemp["cardioTemp"] =
          patients.medicalHistory!.hasCardiovascularProblems;
      pathologyDataTemp["cancerTemp"] =
          patients.medicalHistory!.hasCancerProblems;
      pathologyDataTemp["diabeticTemp"] =
          patients.medicalHistory!.hasDiabeticsProblems;
      pathologyDataTemp["obesyTemp"] =
          patients.medicalHistory!.hasObesityProblems;
      pathologyDataTemp["respTemp"] =
          patients.medicalHistory!.hasRespiratoryProblems;
      pathologyDataTemp["mentalTemp"] =
          patients.medicalHistory!.hasMentalProblems;
      pathologyDataTemp["fluxTemp"] =
          patients.medicalHistory!.hasFrequentFluProblems;

      //Family Data Temp
      familyDataTemp["0"] =
          patients.medicalHistory!.haveRelativesCardiovascularProblems;
      familyDataTemp["1"] =
          patients.medicalHistory!.haveRelativesCancerProblems;
      familyDataTemp["2"] =
          patients.medicalHistory!.haveRelativesDiabeticsProblems;
      familyDataTemp["3"] =
          patients.medicalHistory!.haveRelativesObesityProblems;
      familyDataTemp["4"] =
          patients.medicalHistory!.haveRelativesRespiratoryProblems;
      familyDataTemp["5"] =
          patients.medicalHistory!.haveRelativesMentalProblems;

      //Habit Data Temp
      habitDataTemp["0"] = patients.medicalHistory!.hasDrinkingHabit;
      habitDataTemp["1"] = patients.medicalHistory!.hasSmokingHabit;
      habitDataTemp["2"] = patients.medicalHistory!.hasDrinkingCaffeineHabit;
      habitDataTemp["3"] = patients.medicalHistory!.hasMedication;
      habitDataTemp["4"] = patients.medicalHistory!.hasFitnessHabit;
      habitDataTemp["5"] = patients.medicalHistory!.hasEatingAfterHoursHabit;
    }

    if (patients.lastSoap != null) {
      noteS = patients.lastSoap!.subjective?.note;
      dateS = patients.lastSoap!.subjective?.date;
      historyAnalysis = patients.lastSoap!.subjective?.note;

      noteO = patients.lastSoap!.objective?.note;
      dateO = patients.lastSoap!.objective?.date;
      healthSummary = patients.lastSoap!.objective?.note;

      noteA = patients.lastSoap!.assessment?.note;
      dateA = patients.lastSoap!.assessment?.date;
      assessmentIA = patients.lastSoap!.assessment?.note;

      noteP = patients.lastSoap!.plan?.note;
      dateP = patients.lastSoap!.plan?.date;
      planIA = patients.lastSoap!.plan?.note;
    }
  }

  Future<void> viewOnChanged(ViewState viewState) async {
    state = state.copyWith(viewState: viewState);
  }

  void backStateHistoric(HistoricClinicState historic) {
    if (historic == const HistoricClinicState.dataSO()) {
      state = state.copyWith(
          viewState: const ViewState.historicClinic(
              historicClinicState: HistoricClinicState.dataBasic()));
    } else if (historic == const HistoricClinicState.dataAP()) {
      state = state.copyWith(
          viewState: const ViewState.historicClinic(
              historicClinicState: HistoricClinicState.dataSO()));
    } else if (historic == const HistoricClinicState.reports()) {
      state = state.copyWith(
          viewState: const ViewState.historicClinic(
              historicClinicState: HistoricClinicState.dataAP()));
    } else if (historic == const HistoricClinicState.prescription()) {
      state = state.copyWith(
          viewState: const ViewState.historicClinic(
              historicClinicState: HistoricClinicState.reports()));
    } else if (historic == const HistoricClinicState.prescription()) {
      state = state.copyWith(
          viewState: const ViewState.historicClinic(
              historicClinicState: HistoricClinicState.reports()));
    }
  }

  void nextStateHistoric(HistoricClinicState historic) {
    if (historic == const HistoricClinicState.dataBasic()) {
      state = state.copyWith(
          viewState: const ViewState.historicClinic(
              historicClinicState: HistoricClinicState.dataSO()));
    } else if (historic == const HistoricClinicState.dataSO()) {
      state = state.copyWith(
          viewState: const ViewState.historicClinic(
              historicClinicState: HistoricClinicState.dataAP()));
    } else if (historic == const HistoricClinicState.dataAP()) {
      state = state.copyWith(
          viewState: const ViewStateHistoricClinic(
              historicClinicState: HistoricClinicStateReports()));
    } else if (historic == const HistoricClinicState.reports()) {
      state = state.copyWith(
          viewState: const ViewStateHistoricClinic(
              historicClinicState: HistoricClinicStatePrescription()));
    } else if (historic == const HistoricClinicState.reports()) {
      state = state.copyWith(
          viewState: const ViewStateHistoricClinic(
              historicClinicState: HistoricClinicStatePrescription()));
    }
  }

  void changedSettingState() {
    state.viewState.when(
        clinicState: () {},
        labState: () {},
        historicClinic: (historic) {
          historic.when(
            dataBasic: () {
              state =
                  state.copyWith(isSettingDataBasic: !state.isSettingDataBasic);
            },
            dataPathology: () {
              state = state.copyWith(
                  isSettingDataPathology: !state.isSettingDataPathology);
            },
            dataFamilyHistoric: () {
              state = state.copyWith(
                  isSettingDataFamilyHistoric:
                      !state.isSettingDataFamilyHistoric);
            },
            dataHabit: () {
              state =
                  state.copyWith(isSettingDataHabit: !state.isSettingDataHabit);
            },
            dataFallowed: () {},
            dataSpecialist: () {},
            dataSO: () {},
            dataAP: () {},
            reports: () {},
            prescription: () {},
          );
        });
  }

  Future<void> onChangedDate(DateTime date) async {
    dateCtl.text = DateFormat('yyyy/MM/dd').format(date);
    dateTemp = date;
    birthday = getDateWithFormatToUpload(date);
    notifyListeners();
  }

  bool isDateIsEqual(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day) {
      return true;
    }
    return false;
  }

  void comprobateValues() {
    if (!isDateIsEqual(dateTemp, DateTime.parse(patients.user.birthday)) ||
        emailTemp != patients.user.email ||
        "${codeCountryTemp}-${phoneNumberTemp}" !=
            "${patients.user.countryCode}-${patients.user.phoneNumber}" ||
        occupationTemp != patients.user.occupation ||
        weightTemp != patients.user.weight ||
        heightTemp != patients.user.height) {
      print("Hay datos nuevos para subir");
      print(patients.user.toJson());
      print("#########################");
      print(convertDate(dateTemp.toUtc().toString()));
      print(emailTemp);
      print(codeCountryTemp);
      print(phoneNumberTemp);
      print(occupationTemp);
      print(weightTemp);
      print(heightTemp);
      state = state.copyWith(isSettingDataBasic: false);
    }
  }

  void onChangedDatePathology(String key, bool newValue) {
    state.viewState.when(
        clinicState: () {},
        labState: () {},
        historicClinic: (historic) {
          historic.when(
              dataBasic: () {},
              dataPathology: () {
                if (pathologyDataTemp[key] != newValue) {
                  pathologyDataTemp[key] = newValue;
                  notifyListeners();
                }
              },
              dataFamilyHistoric: () {
                if (familyDataTemp[key] != newValue) {
                  familyDataTemp[key] = newValue;
                  notifyListeners();
                }
              },
              dataHabit: () {
                if (habitDataTemp[key] != newValue) {
                  habitDataTemp[key] = newValue;
                  notifyListeners();
                }
              },
              dataFallowed: () {},
              dataSO: () {},
              dataAP: () {},
              dataSpecialist: () {},
              reports: () {},
              prescription: () {});
        });
  }

  bool _checkNull(Map<String, bool?> myMap) {
    for (bool? value in myMap.values) {
      if (value == null) {
        return false;
      }
    }
    return true;
  }

  bool _checkPathologyDataIsEqual() {
    if (patients.medicalHistory != null) {
      if (patients.medicalHistory!.hasCardiovascularProblems !=
              pathologyDataTemp["cardioTemp"] ||
          patients.medicalHistory!.hasCancerProblems !=
              pathologyDataTemp["cancerTemp"] ||
          patients.medicalHistory!.hasDiabeticsProblems !=
              pathologyDataTemp["diabeticTemp"] ||
          patients.medicalHistory!.hasObesityProblems !=
              pathologyDataTemp["obesyTemp"] ||
          patients.medicalHistory!.hasRespiratoryProblems !=
              pathologyDataTemp["respTemp"] ||
          patients.medicalHistory!.hasMentalProblems !=
              pathologyDataTemp["mentalTemp"] ||
          patients.medicalHistory!.hasFrequentFluProblems !=
              pathologyDataTemp["fluxTemp"]) {
        return true;
      }
      return false;
    }
    return true;
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
        await getDataPatient(patientState: const PatientStateLoading());
      }
    });
  }

  Future<void> setNewNoteS(InputSOAP input) async {
    state = state.copyWith(requestState: const RequestStateFetch());
    final result = await accountRepository.recordNewNoteS(input);
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
    }, right: (note) async {
      if (note != null) {
        noteS = note.note;
        dateS = note.date;
        historyAnalysis = note.note;
        showToast("Datos guardado correctamente.");
        state = state.copyWith(requestState: const RequestStateNormal());
      }
    });
  }

  Future<void> setNewNoteO(InputSOAP input) async {
    state = state.copyWith(requestState: const RequestStateFetch());
    final result = await accountRepository.recordNewNoteO(input);
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
    }, right: (note) async {
      if (note != null) {
        noteO = note.note;
        dateO = note.date;
        healthSummary = note.note;
        showToast("Datos guardado correctamente.");
        state = state.copyWith(requestState: const RequestStateNormal());
      }
    });
  }

  Future<void> setNewNoteA(InputSOAP input) async {
    state = state.copyWith(requestState: const RequestStateFetch());
    final result = await accountRepository.recordNewNoteA(input);
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
    }, right: (note) async {
      if (note != null) {
        noteA = note.note;
        dateA = note.date;
        assessmentIA = note.note;
        showToast("Datos guardado correctamente.");
        state = state.copyWith(requestState: const RequestStateNormal());
      }
    });
  }

  Future<void> setNewNoteP(InputSOAP input) async {
    state = state.copyWith(requestState: const RequestStateFetch());
    final result = await accountRepository.recordNewNoteP(input);
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
    }, right: (note) async {
      if (note != null) {
        noteP = note.note;
        dateP = note.date;
        planIA = note.note;
        showToast("Datos guardado correctamente.");
        state = state.copyWith(requestState: const RequestStateNormal());
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
    weight = null;
    height = null;
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

  void settingChanged() async {
    state = state.copyWith(isFetch: !state.isFetch);
  }

  bool _checkFamilyDataIsEqual() {
    if (patients.medicalHistory != null) {
      if (patients.medicalHistory!.haveRelativesCardiovascularProblems !=
              familyDataTemp["0"] ||
          patients.medicalHistory!.haveRelativesCancerProblems !=
              familyDataTemp["1"] ||
          patients.medicalHistory!.haveRelativesDiabeticsProblems !=
              familyDataTemp["2"] ||
          patients.medicalHistory!.haveRelativesObesityProblems !=
              familyDataTemp["3"] ||
          patients.medicalHistory!.haveRelativesRespiratoryProblems !=
              familyDataTemp["4"] ||
          patients.medicalHistory!.haveRelativesMentalProblems !=
              familyDataTemp["5"]) {
        return true;
      }
      return false;
    }
    return true;
  }

  bool _checkHabitDataIsEqual() {
    if (patients.medicalHistory != null) {
      if (patients.medicalHistory!.hasDrinkingHabit != habitDataTemp["0"] ||
          patients.medicalHistory!.hasSmokingHabit != habitDataTemp["1"] ||
          patients.medicalHistory!.hasDrinkingCaffeineHabit !=
              habitDataTemp["2"] ||
          patients.medicalHistory!.hasMedication != habitDataTemp["3"] ||
          patients.medicalHistory!.hasFitnessHabit != habitDataTemp["4"] ||
          patients.medicalHistory!.hasEatingAfterHoursHabit !=
              habitDataTemp["5"]) {
        return true;
      }
      return false;
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
    final result = await accountRepository.upLoadHistoricMedical(
        medicalHistoryInput, fatherPatient.patientID);

    return result;
  }

  Future<Either<HttpRequestFailure, bool>> checkFamilyData() async {
    Either<HttpRequestFailure, bool> either;
    if (!_checkNull(familyDataTemp)) {
      return either = Either.left(HttpRequestFailure.formData(
          "Por favor complete los datos faltantes"));
    }
    MedicalHistory medicalHistoryInput = const MedicalHistory();
    medicalHistoryInput = medicalHistoryInput.copyWith(
        haveRelativesCardiovascularProblems: familyDataTemp["0"]);
    medicalHistoryInput = medicalHistoryInput.copyWith(
        haveRelativesCancerProblems: familyDataTemp["1"]);
    medicalHistoryInput = medicalHistoryInput.copyWith(
        haveRelativesDiabeticsProblems: familyDataTemp["2"]);
    medicalHistoryInput = medicalHistoryInput.copyWith(
        haveRelativesObesityProblems: familyDataTemp["3"]);
    medicalHistoryInput = medicalHistoryInput.copyWith(
        haveRelativesRespiratoryProblems: familyDataTemp["4"]);
    medicalHistoryInput = medicalHistoryInput.copyWith(
        haveRelativesMentalProblems: familyDataTemp["5"]);
    final result = await accountRepository.upLoadHistoricMedical(
        medicalHistoryInput, fatherPatient.patientID);

    return result;
  }

  Future<Either<HttpRequestFailure, bool>> checkPathologyData() async {
    Either<HttpRequestFailure, bool> either;
    if (!_checkNull(pathologyDataTemp)) {
      return either = Either.left(HttpRequestFailure.formData(
          "Por favor complete los datos faltantes"));
    }
    MedicalHistory medicalHistoryInput = const MedicalHistory();
    medicalHistoryInput = medicalHistoryInput.copyWith(
        hasCardiovascularProblems: pathologyDataTemp["cardioTemp"]);
    medicalHistoryInput = medicalHistoryInput.copyWith(
        hasCancerProblems: pathologyDataTemp["cancerTemp"]);
    medicalHistoryInput = medicalHistoryInput.copyWith(
        hasDiabeticsProblems: pathologyDataTemp["diabeticTemp"]);
    medicalHistoryInput = medicalHistoryInput.copyWith(
        hasObesityProblems: pathologyDataTemp["obesyTemp"]);
    medicalHistoryInput = medicalHistoryInput.copyWith(
        hasRespiratoryProblems: pathologyDataTemp["respTemp"]);
    medicalHistoryInput = medicalHistoryInput.copyWith(
        hasMentalProblems: pathologyDataTemp["mentalTemp"]);
    medicalHistoryInput = medicalHistoryInput.copyWith(
        hasFrequentFluProblems: pathologyDataTemp["fluxTemp"]);

    final result = await accountRepository.upLoadHistoricMedical(
        medicalHistoryInput, fatherPatient.patientID);

    return result;
  }

  Future<Either<HttpRequestFailure, bool>> uploadFollowedMethod() async {
    if (patientsTemp != null) {
      final input = UploadFollowedUpMethodInput(
          patientID: patientsTemp!.patientID,
          followUpMethod: patientsTemp!.followUpMethod != null
              ? patientsTemp!.followUpMethod!
              : []);
      final result = await accountRepository.upLoadFollowedMethod(input);

      return result;
    }
    Either<HttpRequestFailure, bool> either;
    return either = Either.left(
        HttpRequestFailure.formData("Estamos cargando los datos..."));
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
}
