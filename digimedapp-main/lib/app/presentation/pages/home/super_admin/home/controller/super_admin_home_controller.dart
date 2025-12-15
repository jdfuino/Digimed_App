import 'package:digimed/app/data/providers/data_test/data_test.dart';
import 'package:digimed/app/domain/models/item_doctors/item_doctors.dart';
import 'package:digimed/app/domain/models/medical_center/medical_center.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home/controller/state/super_admin_home_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

class SuperAdminHomeController extends StateNotifier<SuperAdminHomeState> {
  SuperAdminHomeController(
    super.state, {
    required this.sessionController,
    required this.accountRepository,
    required this.authenticationRepository,
  });

  final SessionController sessionController;
  final AccountRepository accountRepository;
  final AuthenticationRepository authenticationRepository;

  List<MedicalCenter> listD = [];
  String? urlImage;

  Future<void> init() async {
    await getUrlImage();
    await listMedicalCenter();
  }

  Future<void> getUrlImage() async {
    final result = await accountRepository.getMeUrlImage();

    result.when(
        left: (_) {},
        right: (url) {
          urlImage = url;
        });
  }

  Future<void> listMedicalCenter(
      {MedicalCenterState? medicalCenterState}) async {
    if (medicalCenterState != null) {
      state = state.copyWith(medicalCenterState: medicalCenterState);
    }

    final result = await accountRepository.medicalCenter();

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
            medicalCenterState: MedicalCenterState.failed(failure));
      },
      right: (list) {
        listD = list;
        return state.copyWith(
            medicalCenterState: MedicalCenterState.loaded(list));
      },
    );
  }

  Future<void> searchOnChanged(String text) async {
    state = state.copyWith(medicalCenterState: MedicalCenterState.loading());
    List<MedicalCenter> listFiltrate = listD
        .where((element) =>
            element.name.toLowerCase().contains(text.toLowerCase()) ||
            element.address.toLowerCase().contains(text.toLowerCase()))
        .toList();

    state = state.copyWith(
        medicalCenterState: MedicalCenterState.loaded(listFiltrate));
  }
}
