import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_doctor/controller/state/home_doctor_super_admin_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

class HomeDoctorSuperAdminController extends StateNotifier<HomeDoctorSuperAdminState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  final Doctor doctor;

  HomeDoctorSuperAdminController(
    super.state, {
    required this.accountRepository,
    required this.sessionController,
    required this.doctor,
  });

  List<Patients> listD = [];

  Future<void> init() async {
    await loadListPatients();
  }

  Future<void> loadListPatients({AssociatePatients? associatePatientState}) async {
    if (associatePatientState != null) {
      state = state.copyWith(associatePatientState: associatePatientState);
    }

    final result = await accountRepository.getAdminListPatients(doctor.user.id);
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
      return state.copyWith(
          associatePatientState: const AssociatePatients.failed());
    }, right: (list) {
      listD = list;
      return state.copyWith(associatePatientState: AssociatePatients.loaded(listD));
    });
  }

  Future<void> searchOnChanged(String text) async {
    state =
        state.copyWith(associatePatientState: const AssociatePatients.loading());
    List<Patients> displayList = listD
        .where((element) =>
            element.user.fullName.toLowerCase().contains(text.toLowerCase()) ||
                element.user.identificationNumber.toLowerCase().contains(text.toLowerCase()))
        .toList();

    state = state.copyWith(
        associatePatientState: AssociatePatients.loaded(displayList));
  }
}
