import 'package:digimed/app/domain/models/item_working_hours/item_working_hours.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:digimed/app/domain/models/working_hours_input/working_hours_input.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/setting_hours/admin/controller/state/setting_hours_admin_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

class SettingHoursAdminController
    extends StateNotifier<SettingHoursAdminState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  final int doctorId;
  List<WorkingHours>? listWorking;
  final int index;

  SettingHoursAdminController(super._state,
      {required this.accountRepository,
        this.listWorking,
        required this.sessionController,
        required this.index,
        required this.doctorId
      });

  List<WorkingHours> listSetting = [];
  List<ItemWorkingHours> itemsWorkingHours = [];
  WorkingHoursInput? input;

  Future<void> init() async {
    listSetting = listWorking != null ? listWorking! : [];
    input = WorkingHoursInput(tag: "$doctorId-$index");
    if (listSetting.isNotEmpty) {
      // input = input!.copyWith(startTime0: listSetting[0].startTime0);
      // input = input!.copyWith(stopTime0: listSetting[0].stopTime0);
      // input = input!.copyWith(startTime1: listSetting[0].startTime1);
      // input = input!.copyWith(stopTime1: listSetting[0].stopTime1);

      if (listSetting[0].startTime0 != null &&
          listSetting[0].stopTime0 != null) {
        itemsWorkingHours.add(ItemWorkingHours(
            startTime: listSetting[0].startTime0!,
            stopTime: listSetting[0].stopTime0!));
      }

      if(listSetting[0].startTime1 != null &&
          listSetting[0].stopTime1 != null){
        itemsWorkingHours.add(ItemWorkingHours(
            startTime: listSetting[0].startTime1!,
            stopTime: listSetting[0].stopTime1!));
      }
    }

    state = state.copyWith(isEnabled:
    (listWorking != null && listWorking!.isNotEmpty));
  }

  void enabledChanged(bool value) async {
    state = state.copyWith(isEnabled: value);
  }

  void addNewHour() {
    //TODO:Agregar ID del doctor
    // listSetting.add(WorkingHours(
    //     tag: "-${index}", dayOfWeek: index, stopTime0: "0000-01-01T15:00:00",
    //     startTime0: "0000-01-01T07:00:00"));
    itemsWorkingHours.add(const ItemWorkingHours(
        startTime: "0000-01-01T07:00:00-04:00",
        stopTime: "0000-01-01T15:00:00-04:00"));
    notifyListeners();
  }

  void removeHours(int indexRemove) {
    itemsWorkingHours.removeAt(indexRemove);
    notifyListeners();
  }

  void settingHours(int indexItem,
      String formatTimeOfDay, bool isStart) {
    if (isStart) {
      itemsWorkingHours[indexItem] =
          itemsWorkingHours[indexItem].copyWith(startTime: formatTimeOfDay);
    } else {
      itemsWorkingHours[indexItem] =
          itemsWorkingHours[indexItem].copyWith(stopTime: formatTimeOfDay);
    }
    notifyListeners();
  }

  void checkData() async{
    int i = 0;
    if(itemsWorkingHours.isNotEmpty){
      for(final item in itemsWorkingHours){
        if(i == 0){
          input = input!.copyWith(startTime0: item.startTime);
          input = input!.copyWith(stopTime0: item.stopTime);
        }
        else if(i == 1){
          input = input!.copyWith(startTime1: item.startTime);
          input = input!.copyWith(stopTime1: item.stopTime);
        }
        i += 1;
      }
    }
    print(input!.toJson());
    state = state.copyWith(settingAdminState: const SettingAdminStateLoading());
    final result = await accountRepository.upDateWorkingHours(input!);
    result.when(left:  (failed) {
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
          formData: (String message) {
            showToast(message);
          });
      state = state.copyWith(settingAdminState: const SettingAdminStateNormal());
    }, right: (_) async{
      showToast("Datos guardado correctamente.");
      state = state.copyWith(settingAdminState: const SettingAdminStateNormal());
    });

  }
}
