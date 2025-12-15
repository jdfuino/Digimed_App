import 'dart:ffi';

import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/doctor_specialist/doctor_specialist.dart';
import 'package:digimed/app/domain/models/medical_specialty/medical_specialty.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_specialist/controller/state/form_new_specialist_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

class FormNewSpecialistController
    extends StateNotifier<FormNewSpecialistbState> {
  final int patientId;
  final AccountRepository accountRepository;
  final SessionController sessionController;
  final medicalCenterID;
  final specialtyID;

  FormNewSpecialistController(
    super.state, {
    required this.sessionController,
    required this.accountRepository,
    required this.patientId,
    required this.medicalCenterID,
    required this.specialtyID,
  });

  bool showDoctors = false;

  void init() async {
    await getMedicalsSpecialty();
    showDoctors = false;
  }

  List<DoctorSpecialists> listD = [];
  List<MedicalSpecialty> listS = [];

  Future<void> ListDoctorsSpecialist(
      {AssociateSpecialist? associateSpecialist}) async {
    if (associateSpecialist != null) {
      state = state.copyWith(associateSpecialist: associateSpecialist);
    }

    final result = await accountRepository.getListDoctorsSpecialist(
        medicalCenterID, specialtyID);

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
            associateSpecialist: AssociateSpecialist.failed(failure));
      },
      right: (list) {
        listD = list;
        return state.copyWith(
            associateSpecialist: AssociateSpecialist.loaded(list));
      },
    );
  }

  Future<void> searchOnChanged(String text) async {
    state = state.copyWith(
        associateSpecialist: const AssociateSpecialist.loading());
    List<DoctorSpecialists> displayList = listD
        .where((element) =>
            element.fullName.toLowerCase().contains(text.toLowerCase()) ||
            element.medicalSpecialties.contains(text.toLowerCase()))
        .toList();

    state = state.copyWith(
        associateSpecialist: AssociateSpecialist.loaded(displayList));
  }

  // Toma las esoecialidades medicas de la consulta en accountRepository
  Future<void> getMedicalsSpecialty(
      {MedicalSpecialtyState? medicalSpecialtyState}) async {
    if (medicalSpecialtyState != null) {
      state = state.copyWith(medicalSpecialtyState: medicalSpecialtyState);
    }

    final result = await accountRepository.medicalSpecialties();

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
            medicalSpecialtyState: MedicalSpecialtyState.failed(failure));
      },
      right: (list) {
        listS = list;
        return state.copyWith(
            medicalSpecialtyState: MedicalSpecialtyState.loaded(list));
      },
    );
  }

  Future<void> getListDoctor(
      {AssociateSpecialist? associateSpecialist,
      required int idSpecialist}) async {
    if (associateSpecialist != null) {
      state = state.copyWith(associateSpecialist: associateSpecialist);
    }
    Doctor? me = sessionController.doctor;

    final result = await accountRepository.getListDoctorsSpecialist(
        me!.medicalCenters![0].id, idSpecialist);

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
            associateSpecialist: AssociateSpecialist.failed(failure));
      },
      right: (list) {
        return state.copyWith(
            associateSpecialist: AssociateSpecialist.loaded(list));
      },
    );
  }

  Future<bool> setDoctorSpecialist(
      {AssociateSpecialist? associateSpecialist, required int doctorId}) async {
    if (associateSpecialist != null) {
      state = state.copyWith(associateSpecialist: associateSpecialist);
    }
    print("patientID: $patientId");
    print("doctorID: $doctorId");

    final result =
        await accountRepository.assignSpecialist(patientId, doctorId);

    bool data = false;

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
            associateSpecialist: AssociateSpecialist.failed(failure));
      },
      right: (dataBool) {
        data = dataBool;
        return state.copyWith(
            associateSpecialist: AssociateSpecialist.loaded(listD));
      },
    );
    return data;
  }
}
