import 'package:digimed/app/domain/constants/treatment_status.dart';
import 'package:digimed/app/domain/models/treatment/treatment.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/treatments/controller/state/treatment_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

import '../../../../domain/globals/logger.dart';

class TreatmentController extends StateNotifier<TreatmentState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;

  TreatmentController(super._state,
      {required this.accountRepository, required this.sessionController});

  Future<void> onRefresh({TreatmentState? notificationState}) async {
    if (notificationState == null) {
      state = state.copyWith(
          treatmentsFetchState: const TreatmentsFetchStateLoading());
    }

    final result =
        await accountRepository.getMePatient(sessionController.state!);

    result.when(left: (_) {
      state = state.copyWith(
          treatmentsFetchState: const TreatmentsFetchStateLoaded([]));
    }, right: (patient) {
      sessionController.patients = patient;
      state = state.copyWith(
          treatmentsFetchState:
              TreatmentsFetchStateLoaded(patient!.treatments));
    });
  }

  Future<void> initTreatment(Treatment treatment) async {
    logger.i("Iniciando tratamiento ${treatment.id}");
    final result = await accountRepository.updateTreatment(
        treatment.id, TreatmentStatus.inProgress.value);
    result.when(left: (_) {
      showToast("Error al iniciar el tratamiento");
    }, right: (data) {
      if (data != null && data) {
        showToast("Tratamiento iniciado");
        onRefresh();
      }
    });
  }
}
