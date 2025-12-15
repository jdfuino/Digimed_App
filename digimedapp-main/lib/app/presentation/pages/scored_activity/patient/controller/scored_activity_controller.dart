import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/scored_activity/patient/controller/state/scored_activity_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

class ScoredActivityController extends StateNotifier<ScoredActivityState>{
  final AccountRepository accountRepository;
  final SessionController sessionController;
  final int userID;

  ScoredActivityController(super.state,{
    required this.accountRepository,
    required this.sessionController,
    required this.userID
  });

  Future<void> init() async {
    await getMyActivitys();
  }

  Future<void> getMyActivitys({ActivityDataState? activityDataState}) async{
    if(activityDataState != null){
      state = state.copyWith(activityDataState: activityDataState);
    }

    final result = await accountRepository.getMyActivitys(userID);

    state = result.when(
        left: (failure) {
          failure.when(
              notFound: ()=>  showToast("Datos no encontrado"),
              network: ()=>  showToast("No hay conexion con Internet"),
              unauthorized: ()=>  showToast("No estas autorizado para realizar esta accion"),
              tokenInvalided: (){
                showToast("Sesion expirada");
                sessionController.globalCloseSession();
              },
              unknown: ()=>  showToast("Hemos tenido un problema"),
              emailExist:()=>  showToast("Email no existe"),
              formData: (String message) {showToast(message);  });
          return state.copyWith(activityDataState: ActivityDataState.failed(failure));
        },
        right: (list) {
          return state.copyWith(
              activityDataState: ActivityDataState.loaded(list));
        });
  }
}