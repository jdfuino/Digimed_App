import 'package:digimed/app/data/providers/data_test/data_test.dart';
import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/user_input/user_input.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/code_verification/controller/state/code_verification_state.dart';

class CodeVerificationController extends StateNotifier<CodeVerificationState> {
  int? userID;
  final AuthenticationRepository authenticationRepository;
  String? textCode;

  CodeVerificationController(
    super.state, {
    required this.authenticationRepository,
  });

  void onCodeChanged(String text) {
    onlyUpdate(
      state.copyWith(
        code: text,
        // En caso de ser necesario cambiar el tipo de dato del codigo de verificacion de String a Int.
      ),
    );
  }

  Future<Either<HttpRequestFailure, User>> verificateCode() async {
    state = state.copyWith(fetching: true);
    final result = await authenticationRepository
        .recoveryPasswordCodeVerification(state.code);

    result.when(
      left: (_) => state = state.copyWith(fetching: false),
      right: (user) {
        return Either.right(user);
      },
    );

    return result;
  }
}
