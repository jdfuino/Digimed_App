import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/location_input/location_input.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/domain/repositories/position_repository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/request_location_doctor_dialog.dart';
import 'package:digimed/app/presentation/pages/home/doctor/home/controller/state/home_doctor_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeDoctorController extends StateNotifier<HomeDoctorState> {
  final AccountRepository accountRepository;
  final PositionRepository positionRepository;
  final SessionController sessionController;
  final Doctor doctor;
  final BuildContext context;

  HomeDoctorController(super.state,
      {required this.accountRepository,
      required this.positionRepository,
      required this.sessionController,
      required this.context,
      required this.doctor});

  List<Patients> listD = [];
  Position? positionDoctor;

  Future<void> init() async {
    await loadListPatients();
    await checkPosition();
  }

  void showRequestLocationDialog() {
    showDialog(
        context: context,
        builder: (context) => RequestLocationDoctorDialog(
              onFinish: () async {
                await checkPositionDialog();
              },
            ));
  }

  Future<void> checkPosition() async {
    if (await positionRepository.checkServiceLocation()) {
      LocationPermission permission =
          await positionRepository.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("location permission denied");
        showRequestLocationDialog();
        //permission = await positionRepository.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          print("location permission denied again");
          // showRequestLocationDialog();
        } else {
          positionDoctor = await positionRepository.getCurrentLocation();
          if (positionDoctor != null) {
            await uploadNewRecord();
          }
        }
      } else if (permission == LocationPermission.deniedForever) {
        print("location permission denied for ever");
      } else {
        positionDoctor = await positionRepository.getCurrentLocation();
        if (positionDoctor != null) {
          await uploadNewRecord();
        }
      }
    } else {
      print("location service disable");
    }
  }

  Future<void> checkPositionDialog() async {
    if (await positionRepository.checkServiceLocation()) {
      LocationPermission permission =
          await positionRepository.checkPermission();
      if (permission == LocationPermission.denied) {
        print("location permission denied");
        permission = await positionRepository.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          print("location permission denied again");
          //showRequestLocationDialog();
        } else {
          positionDoctor = await positionRepository.getCurrentLocation();
          if (positionDoctor != null) {
            await uploadNewRecord();
          }
        }
      } else if (permission == LocationPermission.deniedForever) {
        print("location permission denied for ever");
      } else {
        positionDoctor = await positionRepository.getCurrentLocation();
        if (positionDoctor != null) {
          await uploadNewRecord();
        }
      }
    } else {
      print("location service disable");
    }
  }

  Future<void> uploadNewRecord() async {
    LocationInput locationInput = LocationInput(
        userID: doctor.user.id,
        latitude: positionDoctor!.latitude,
        longitude: positionDoctor!.longitude);
    final result = await accountRepository.recordNewLocation(locationInput);

    result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () {
            showToast("Sesion expirada");
          },
          orElse: () {});
    }, right: (_) {
      print("Location update");
    });
  }

  Future<void> loadListPatients(
      {AssociateDoctorPatients? associatePatients}) async {
    if (associatePatients != null) {
      state = state.copyWith(associatePatients: associatePatients);
    }
    final result = await accountRepository.getAdminListPatients(doctor.user.id);
    state = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () {
            showToast("Sesion expirada");
            sessionController.globalCloseSession();
          },
          orElse: () {});
      return state.copyWith(
          associatePatients: const AssociateDoctorPatients.failed());
    }, right: (list) {
      listD = list;
      return state.copyWith(
          associatePatients: AssociateDoctorPatients.loaded(listD));
    });
  }

  Future<void> searchOnChanged(String text) async {
    state = state.copyWith(
        associatePatients: const AssociateDoctorPatients.loading());
    List<Patients> displayList = listD
        .where((element) =>
            element.user.fullName.toLowerCase().contains(text.toLowerCase()) ||
            element.user.identificationNumber
                .toLowerCase()
                .contains(text.toLowerCase()))
        .toList();

    state = state.copyWith(
        associatePatients: AssociateDoctorPatients.loaded(displayList));
  }
}
