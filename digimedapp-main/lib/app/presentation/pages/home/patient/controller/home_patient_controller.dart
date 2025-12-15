import 'package:digimed/app/domain/constants/treatment_status.dart';
import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/domain/models/location_input/location_input.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/models/treatment/treatment.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/domain/repositories/position_repository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/pending_treatment_dialog.dart';
import 'package:digimed/app/presentation/global/widgets/request_location_patient_dialog.dart';
import 'package:digimed/app/presentation/pages/home/patient/controller/state/home_patient_state.dart';
import 'package:digimed/app/presentation/pages/treatments/controller/state/treatment_state.dart';
import 'package:digimed/app/presentation/pages/treatments/views/treatment_page.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomePatientController extends StateNotifier<HomePatientState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  final PositionRepository positionRepository;
  Patients patients;
  final BuildContext context;
  Position? positionPatient;

  HomePatientController(super.state,
      {required this.accountRepository,
      required this.sessionController,
      required this.positionRepository,
      required this.context,
      required this.patients});

  Future<void> init() async {
    await refreshMePatient();
    await checkPosition();
    await checkTreatment();
  }

  void showRequestLocationDialog() async {
    await showDialog(
        context: context,
        builder: (context) => RequestLocationPatientDialog(
              onFinish: () async {
                await checkPositionDialog();
              },
            ));
  }

  Future<void> checkTreatment() async {
    Patients? patients = sessionController.patients;
    logger.i(patients!.treatments);
    if (patients != null && patients.treatments.isNotEmpty) {
      Treatment? treatment = checkTreatmentPending(patients.treatments);
      if (treatment != null) {
        showDialog(
            context: context,
            builder: (context) => PendingTreatmentDialog(
                patientName: sessionController.state!.fullName,
                treatmentName: treatment.name,
                onStartTreatment: () {
                  initTreatment(treatment);
                },
                onViewTreatments: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const TreatmentPage(),
                    withNavBar: true,
                  );
                }));
      }
    }
  }

  Future<void> initTreatment(Treatment treatment) async {
    logger.i("Iniciando tratamiento ${treatment.id}");
    final result = await accountRepository.updateTreatment(
        treatment.id, TreatmentStatus.inProgress.value);
    result.when(left: (_){
      showToast("Error al iniciar el tratamiento");
    }, right: (data){
      if(data != null && data){
        showToast("Tratamiento iniciado");
      }
    });
  }

  Future<void> checkPosition() async {
    if (await positionRepository.checkServiceLocation()) {
      LocationPermission permission =
          await positionRepository.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        logger.w("location permission denied");
        showRequestLocationDialog();
        //permission = await positionRepository.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          logger.w("location permission denied again");
          //showRequestLocationDialog();
        } else {
          positionPatient = await positionRepository.getCurrentLocation();
          if (positionPatient != null) {
            await uploadNewRecord();
          }
        }
      } else if (permission == LocationPermission.deniedForever) {
        logger.w("location permission denied for ever");
      } else {
        positionPatient = await positionRepository.getCurrentLocation();
        if (positionPatient != null) {
          await uploadNewRecord();
        }
      }
    } else {
      logger.e("location service disable");
    }
  }

  Future<void> checkPositionDialog() async {
    if (await positionRepository.checkServiceLocation()) {
      LocationPermission permission =
          await positionRepository.checkPermission();
      if (permission == LocationPermission.denied) {
        logger.w("location permission denied");
        permission = await positionRepository.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          logger.w("location permission denied again");
          //showRequestLocationDialog();
        } else {
          positionPatient = await positionRepository.getCurrentLocation();
          if (positionPatient != null) {
            await uploadNewRecord();
          }
        }
      } else if (permission == LocationPermission.deniedForever) {
        logger.w("location permission denied for ever");
      } else {
        positionPatient = await positionRepository.getCurrentLocation();
        if (positionPatient != null) {
          await uploadNewRecord();
        }
      }
    } else {
      logger.w("location service disable");
    }
  }

  Future<void> uploadNewRecord() async {
    LocationInput locationInput = LocationInput(
        userID: sessionController.patients!.user.id,
        latitude: positionPatient!.latitude,
        longitude: positionPatient!.longitude);
    final result = await accountRepository.recordNewLocation(locationInput);

    result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () {
            showToast("Sesion expirada");
            sessionController.globalCloseSession();
          },
          orElse: () {});
    }, right: (_) {
      logger.i("Location update");
    });
  }

  Future<void> refreshMePatient(
      {AssociatePatientPatients? associatePatientPatients}) async {
    if (associatePatientPatients != null) {
      state = state.copyWith(associatePatients: associatePatientPatients);
    }
    final result = await accountRepository.getMePatient(patients.user);
    state = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () {
            showToast("Sesion expirada");
            sessionController.globalCloseSession();
          },
          orElse: () {});
      return state.copyWith(
          associatePatients: const AssociatePatientPatients.failed());
    }, right: (newPatient) {
      if (newPatient != null) {
        logger.i(newPatient.toJson());
        sessionController.patients = newPatient;
        sessionController.setUser(newPatient.user);
        patients = newPatient;
        sessionController.notifyListeners();
      }
      return state.copyWith(
          associatePatients: AssociatePatientPatients.loaded(newPatient));
    });
  }
}
