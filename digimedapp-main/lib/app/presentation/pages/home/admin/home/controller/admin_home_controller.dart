import 'package:digimed/app/domain/models/item_doctors/item_doctors.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/home/admin/home/controller/state/admin_home_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

class AdminHomeController extends StateNotifier<AdminHomeState> {
  AdminHomeController(super.state,
      {required this.sessionController,
      required this.authenticationRepository,
      required this.accountRepository});

  final SessionController sessionController;
  final AccountRepository accountRepository;
  final AuthenticationRepository authenticationRepository;
  List<ItemDoctors> listD = [];
  String? urlImage;
  List<int> listIdMedicalCenters = [];

  Future<void> init() async {
    await getUrlImage();
    await loadListCenterMedical();
  }

  Future<void> getUrlImage() async {
    final result = await accountRepository.getMeUrlImage();

    result.when(
        left: (_) {},
        right: (url) {
          urlImage = url;
        });
  }

  Future<void> loadListCenterMedical(
      {AssociateDoctors? associateDoctors}) async {
    if (associateDoctors != null) {
      state = state.copyWith(associateDoctors: associateDoctors);
    }

    final result = await accountRepository
        .medicalCenterIdForCordinator(sessionController.state!.id);

    state = await result.when(left: (failure) {
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
      return state.copyWith(associateDoctors: AssociateDoctors.failed(failure));
    }, right: (list) async {
      if (list.isNotEmpty) {
        listIdMedicalCenters = list;
        return loadListDoctors();
      }
      return state.copyWith(
          associateDoctors: const AssociateDoctors.loaded([]));
    });
  }

  Future<AdminHomeState> loadListDoctors(
      {AssociateDoctors? associateDoctors}) async {

    if (listIdMedicalCenters.isEmpty) {
      return state.copyWith(
          associateDoctors: const AssociateDoctors.loaded([]));
    }

    if (associateDoctors != null) {
      state = state.copyWith(associateDoctors: associateDoctors);
    }

    final result =
        await accountRepository.getCordinatorListDoctors(listIdMedicalCenters);

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
      return state.copyWith(associateDoctors: AssociateDoctors.failed(failure));
    }, right: (list) {
      listD = list;
      return state.copyWith(associateDoctors: AssociateDoctors.loaded(list));
    });

    return state;
  }

  Future<void> searchOnChanged(String text) async {
    state = state.copyWith(associateDoctors: const AssociateDoctors.loading());
    List<ItemDoctors> displayList = listD
        .where((element) =>
            element.user.fullName.toLowerCase().contains(text.toLowerCase()) ||
            element.user.identificationNumber
                .toLowerCase()
                .contains(text.toLowerCase()))
        .toList();

    state =
        state.copyWith(associateDoctors: AssociateDoctors.loaded(displayList));
  }
}
