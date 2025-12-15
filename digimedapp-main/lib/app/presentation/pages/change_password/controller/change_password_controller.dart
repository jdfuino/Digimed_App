import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:digimed/app/presentation/pages/change_password/controller/state/change_password_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

class ChangePasswordController extends StateNotifier<ChangePasswordState> {
  final AuthenticationRepository authenticationRepository;
  final SessionController sessionController;
  final String email;
  final String otpCode;
  ChangePasswordController(
    super._state, {
    required this.authenticationRepository,
    required this.sessionController,
    required this.email,
    required this.otpCode,
  });

  String? password, confirmPassword;
  bool isFetch = false;
  bool? showLogin;

  void onVisibilityPasswordChanged(bool isVisibility) {
    state = state.copyWith(isVisiblePassword: isVisibility);
  }

  // Future<Either<HttpRequestFailure, bool>> changePassword() async {
  //   if (confirmPassword != null) {
  //     state = state.copyWith(requestState: const RequestState.fetch());
  //     final result = await authenticationRepository.recoveryPassword(
  //         confirmPassword!, userid);

  //     result.when(left: (failed) {
  //       failed.when(
  //           notFound: () => showToast("Datos no encontrado"),
  //           network: () => showToast("No hay conexion con Internet"),
  //           unauthorized: () =>
  //               showToast("No estas autorizado para realizar esta accion"),
  //           tokenInvalided: () {
  //             showToast("Sesion expirada");
  //             sessionController.globalCloseSession();
  //           },
  //           unknown: () => showToast("Hemos tenido un problema"),
  //           emailExist: () => showToast("Email ya registrado"),
  //           formData: (String message) {
  //             showToast(message);
  //           });
  //       state = state.copyWith(requestState: RequestState.normal());
  //     }, right: (status) async {
  //       state = state.copyWith(requestState: RequestState.normal());
  //       if (status) {
  //         showToast("Datos guardado correctamente.");
  //       }
  //       return result;
  //     });
  //   }
  //   return Left(HttpRequestFailure.unknown());
  // }

  //Mejorada
  Future<Either<HttpRequestFailure, bool>> changePassword() async {
    if (confirmPassword == null || confirmPassword!.isEmpty) {
      return Left(HttpRequestFailure.formData("Confirma la contraseña"));
    }

    state = state.copyWith(requestState: const RequestState.fetch());
    final result = await authenticationRepository.recoveryPassword(
        confirmPassword!, email, otpCode);

    result.when(
      left: (failed) {
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
          formData: (String message) => showToast(message),
        );
        state = state.copyWith(requestState: const RequestState.normal());
      },
      right: (isValidation) async {
        state = state.copyWith(requestState: const RequestState.normal());
        if (isValidation) {
          showToast("Datos guardado correctamente.");
          showLogin = true;
        }
        return result;
      },
    );
    return Left(HttpRequestFailure.unknown());
  }
}
