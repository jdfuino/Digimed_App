import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/models/recipe/recipe.dart';
import 'package:digimed/app/domain/models/report/report.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/reports_patients/controller/state/reports_patient_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

class ReportsPatientController extends StateNotifier<ReportsPatientState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  Patients patients;
  List<Report> listD = [];
  List<Recipe> listP = [];
  List listOption = ["1 semana", "1 mes", "6 meses", "1 año"];
  String valueSelected = "6 meses";
  bool isReports = true;

  ReportsPatientController(super.state,
      {required this.accountRepository,
      required this.sessionController,
      required this.patients});

  Future<void> init() async {
    await getMeDoctor();
    await loadReports();
    await loadRecipe();
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

  Future<void> loadReports({ReportFetchState? reportFetchState}) async {
    if (reportFetchState != null) {
      state = state.copyWith(reportFetchState: reportFetchState);
    }

    final result = await accountRepository.getReportsByPatientID(
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
            reportFetchState: const ReportFetchState.loaded([]));
      },
      right: (list) {
        listD = list;
        return state.copyWith(
            reportFetchState: ReportFetchState.loaded(list));
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
        listP = list;
        return state.copyWith(recipeFetchState: RecipeFetchState.loaded(list));
      },
    );
  }

  Future<void> getReportBase64(
      {ReportFetchState? reportFetchState, required int reportID}) async {
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
      right: (data) {
        createAndSavePdfFromBase64(
            base64String: data, patientName: patients.user.fullName);
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

  Future<void> searchOnChanged(String text) async {
    // state = state.copyWith(reportFetchState:const ReportFetchState.loading());
    // List<Report> listSearch= listD;
    // if(!isReports){
    //   listSearch = listP;
    // }
    // List<Report> displayList = listSearch
    //     .where((element) =>
    // element.title.toLowerCase().contains(text.toLowerCase()) ||
    //     element.createdAt.toLowerCase()
    //         .contains(text.toLowerCase()))
    //     .toList();
    // state =
    //     state.copyWith(reportFetchState: ReportFetchState.loaded(displayList));
  }
}
