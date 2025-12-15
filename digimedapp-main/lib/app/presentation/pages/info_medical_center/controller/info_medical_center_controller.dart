import 'package:digimed/app/domain/models/coordinador_medical_center/coordinator_medical_center.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/info_medical_center/controller/state/info_medical_center_state.dart';

class InfoMedicalCenterController
    extends StateNotifier<InfoMedicalCenterState> {
  final AccountRepository accountRepository;
  final AuthenticationRepository authenticationRepository;
  final SessionController sessionController;
  final medicalCenterId;

  InfoMedicalCenterController(super._state,
      {required this.accountRepository,
      required this.authenticationRepository,
      required this.medicalCenterId,
      required this.sessionController});

  List<CoordinatorMedicalCenter> listD = [];

  Future<void> init() async {}
}
