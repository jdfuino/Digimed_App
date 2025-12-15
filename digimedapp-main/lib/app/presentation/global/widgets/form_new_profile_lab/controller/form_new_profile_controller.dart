import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/profile_lab_input/profile_lab_input.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/failures/failures_form/failure_form.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_profile_lab/controller/state/form_new_profile_lab_state.dart';

class FormNewProfileLabController
    extends StateNotifier<FormNewProfileLabState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  final int patientId;

  FormNewProfileLabController(super.state, {required this.accountRepository,
  required this.patientId, required this.sessionController});

  late double glucemia, triglicerios, colesterol, hemoglobina;
  double acidoUrico = 0.0;

  Future<Either<HttpRequestFailure, bool>> checkedData() async {
    //onlyUpdate(state.copyWith(fetching: true));
    ProfileLabInput profileLabInput = ProfileLabInput(
        patientID: patientId,
        glucose: glucemia,
        triglycerides: triglicerios,
        cholesterol: colesterol,
        hemoglobin: hemoglobina,
        uricAcid: acidoUrico);
    state = state.copyWith(requestState: const RequestStateFetch());
    final result = await accountRepository.createNewProfileLab(profileLabInput,
    sessionController.doctor != null ?sessionController.doctor!.idDoctor : 1);
    onlyUpdate(state.copyWith(fetching: false));
    result.when(left: (_){
      state = state.copyWith(requestState: const RequestStateNormal());
    }, right: (_){
      state = state.copyWith(requestState: const RequestStateNormal());
    });
    return result;
  }
}
