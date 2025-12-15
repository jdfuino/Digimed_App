import 'package:digimed/app/domain/models/coordinador_medical_center/coordinator_medical_center.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/info_medical_center/controller/state/info_medical_center_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

class InfoCoordinatorController
    extends StateNotifier<InfoMedicalCenterState> {
  final AccountRepository accountRepository;
  final AuthenticationRepository authenticationRepository;
  final SessionController sessionController;

  InfoCoordinatorController(super._state,
      {required this.accountRepository,
      required this.authenticationRepository,
      required this.sessionController});

  List<User> listD = [];

  Future<void> init() async {
    await listMedicalCenterCoordinator();
  }

  Future<void> listMedicalCenterCoordinator(
      {RequestState? requestState}) async {
    if (requestState != null) {
      state = state.copyWith(requestState: requestState);
    }

    final result = await accountRepository.medicalCenterCoordinator(1);

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
        return state.copyWith(requestState: RequestState.failed(failure));
      },
      right: (list) {
        listD = list;
        return state.copyWith(requestState: RequestState.loaded(list));
      },
    );
  }

  Future<void> searchOnChanged(String text) async {
    state = state.copyWith(requestState: RequestState.loading());
    List<User> listFiltrate = listD
        .where((element) =>
            element.fullName.toLowerCase().contains(text.toLowerCase()) ||
            element.phoneNumber.toLowerCase().contains(text.toLowerCase()))
        .toList();

    state = state.copyWith(
        requestState: RequestState.loaded(listFiltrate));
  }
}
