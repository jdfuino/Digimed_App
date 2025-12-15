import 'package:digimed/app/domain/models/item_doctors/item_doctors.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_coordinator/controller/state/super_admin_home_coordinator_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

class SuperAdminHomeCoordinatorController
    extends StateNotifier<SuperAdminHomeCoordinatorState> {
  final SessionController sessionController;
  final AccountRepository accountRepository;
  final AuthenticationRepository authenticationRepository;
  final int idMedicalCenter;
  List<ItemDoctors> listD = [];
  String? urlImage;

  SuperAdminHomeCoordinatorController(super.state,
      {required this.sessionController,
      required this.authenticationRepository,
      required this.idMedicalCenter,
      required this.accountRepository});

  Future<void> init() async {
    await getUrlImage();
    await loadListDoctors();
  }

  Future<void> getUrlImage() async {
    final result = await accountRepository.getMeUrlImage();

    result.when(
        left: (_) {},
        right: (url) {
          urlImage = url;
        });
  }

  Future<void> loadListDoctors({ListDoctors? listDoctors}) async {
    if (listDoctors != null) {
      state = state.copyWith(listDoctors: listDoctors);
    }

    final result = await accountRepository.getAdminCoordinatorListDoctors(idMedicalCenter);

    state = result.when(left: (failure) {
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
      return state.copyWith(listDoctors: ListDoctors.failed(failure));
    }, right: (list) {
      // TODO: Armando quitar la logica actual y poner la que esta comentada
      listD = list;
      return state.copyWith(
          listDoctors: ListDoctors.loaded(list));
    });
  }

  Future<void> searchOnChanged(String text) async {
    state = state.copyWith(listDoctors: const ListDoctors.loading());
    List<ItemDoctors> displayList = listD
        .where((element) =>
            element.user.fullName.toLowerCase().contains(text.toLowerCase()) ||
            element.user.identificationNumber
                .toLowerCase()
                .contains(text.toLowerCase()))
        .toList();

    state = state.copyWith(listDoctors: ListDoctors.loaded(displayList));
  }
}
