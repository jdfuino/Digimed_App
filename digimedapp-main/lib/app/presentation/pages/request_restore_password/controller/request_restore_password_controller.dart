import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/request_restore_password/controller/state/request_restore_password_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

class RequestPasswordController extends StateNotifier<RequestPasswordState> {
  final AuthenticationRepository authenticationRepository;
  String? textEmail;
  RequestPasswordController(super.state,
      {required this.authenticationRepository});

  void onUsernameChanged(String text) {
    onlyUpdate(
      state.copyWith(
        requestEmail: text.trim().toLowerCase(),
      ),
    );
  }

  Future<Either<HttpRequestFailure, bool>> requestRestorePasswrod() async {
      final result = await authenticationRepository
          .recoveryPasswordEmailVerification(state.requestEmail);

      return result.when(left: (failure) {
        failure.when(
          notFound: () => showToast("Datos no encontrado"),
          network: () => showToast("No hay conexion con Internet"),
          unauthorized: () =>
              showToast("No estas autorizado para realizar esta accion"),
          tokenInvalided: () {
            showToast("Sesion expirada");
          },
          unknown: () => showToast("Hemos tenido un problema"),
          emailExist: () => showToast("Email ya registrado"),
          formData: (String message) {
            showToast(message);
          },
        );
        return Either.left(failure);
      }, right: (isValid) {
        return Either.right(isValid);
      });
  }
}
    //   state = state.copyWith(fetching: true);
    //   // TODO: Subir el email del usuario... capturado en el
    //   // onChanged input esta guardado en el state.requestEmail
    //   // si es right pasa lo a la ventana de cambio de contrasena
    //   // si es left muestra un mensaje acorde
    //   await Future.delayed(
    //     Duration(seconds: 5),
    //   );
    //   state = state.copyWith(fetching: false);
    //   return Either.right(true);