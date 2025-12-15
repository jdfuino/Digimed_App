import 'package:digimed/app/data/providers/data_test/data_test.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/info_doctor/admin/controller/state/info_doctor_admin_state.dart';
import 'package:digimed/app/presentation/pages/resumen_hours/admin/resumen_hours/controller/state/resumen_hours_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

class ResumeHoursController extends StateNotifier<ResumeHoursState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  final int fatherId;
  int? doctorID;

  ResumeHoursController(super._state,
      {required this.accountRepository,
      required this.sessionController,
      required this.fatherId});

  Future<void> init() async {
    await getDataDoctor();
  }

  Future<void> getDataDoctor({DoctorDataState? doctorDataState}) async {
    if (doctorDataState != null) {
      state = state.copyWith(doctorDataState: doctorDataState);
    }
    final result =
        await accountRepository.getDoctorWithPointsAndHours(fatherId);
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
      return state.copyWith(doctorDataState: DoctorDataState.faild(failed));
    }, right: (doctor) {
      doctorID = doctor.idDoctor;
      return state.copyWith(
          doctorDataState: DoctorDataState.sucess(
              user: doctor.user,
              list: doctor.hours,
              doctorUserPointsHours: doctor));
    });
  }
}
