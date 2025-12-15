import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/user_data_input/user_data_input.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:digimed/app/presentation/pages/info_doctor/super_admin/controller/state/info_doctor_super_admin_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InfoDoctorSuperAdminController extends StateNotifier<InfoDoctorSuperAdminState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  final int fatherId;

  late User userTemp;
  late int doctorId;
  bool isUpload = false;
  String? birthday;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? occupation;

  TextEditingController dateCtl = TextEditingController();

  InfoDoctorSuperAdminController(super._state, {
    required this.accountRepository,
    required this.sessionController,
    required this.fatherId});

  Future<void> init() async {
    await getDataDoctor();
  }

  Future<void> getDataDoctor({DoctorDataInfoState? doctorDataInfoState}) async {
    if(doctorDataInfoState != null){
      state = state.copyWith(doctorDataInfoState: doctorDataInfoState);
    }
    final result = await accountRepository.getDoctorWithPointsAndHours(fatherId);
    state =  result.when(left: (failed) {
      failed.when(
          notFound: ()=>  showToast("Datos no encontrado"),
          network: ()=>  showToast("No hay conexion con Internet"),
          unauthorized: ()=>
              showToast("No estas autorizado para realizar esta accion"),
          tokenInvalided: (){
            showToast("Sesion expirada");
            sessionController.globalCloseSession();
          },
          unknown: ()=>  showToast("Hemos tenido un problema"),
          emailExist:()=>  showToast("Email ya registrado"),
          formData: (String message) {showToast(message);  });
      return state.copyWith(doctorDataInfoState: DoctorDataInfoState.faild(failed));
    }, right: (doctor)  {
      userTemp = doctor.user;
      doctorId = doctor.idDoctor;
      return state.copyWith(doctorDataInfoState: DoctorDataInfoState.sucess(
          user: doctor.user, list: doctor.hours,doctorUserPointsHours: doctor));
    });
  }

  Future<void> setDataBasic(UserDataInput userDataInput)
  async{
    state = state.copyWith(requestState: const RequestStateFetch());
    final result = await accountRepository.setDataBasic(userDataInput,
        userTemp.id);
    await result.when(
        left: (failed){
          failed.when(
              notFound: ()=>  showToast("Datos no encontrado"),
              network: ()=>  showToast("No hay conexion con Internet"),
              unauthorized: ()=>
                  showToast("No estas autorizado para realizar esta accion"),
              tokenInvalided: (){
                showToast("Sesion expirada");
                sessionController.globalCloseSession();
              },
              unknown: ()=>  showToast("Hemos tenido un problema"),
              emailExist:()=>  showToast("Email ya registrado"),
              formData: (String message) { showToast(message); });
          state = state.copyWith(requestState: const RequestStateNormal());
        },
        right: (value) async{
          if(value){
            resetData();
            showToast("Datos guardado correctamente.");
            state = state.copyWith(requestState: const RequestStateNormal());
            await getDataDoctor(doctorDataInfoState: const DoctorDataInfoStateLoading());
          }
        });
  }

  void settingChanged() async{
    state = state.copyWith(isSetting: !state.isSetting);
  }

  void resetData(){
    isUpload = false;
    birthday = null;
    email = null;
    countryCode = null;
    phoneNumber = null;
    occupation = null;
  }

  Future<void> onChangedDate(DateTime date) async {
    dateCtl.text = DateFormat('yyyy/MM/dd').format(date);
    birthday = getDateWithFormatToUpload(date);
    notifyListeners();
  }

  void checkData() async {
    UserDataInput userDataInput = const UserDataInput();

    if (birthday != null){
      userDataInput = userDataInput.copyWith(birthday: birthday);
      isUpload = true;
    }

    if(email != null){
      userDataInput = userDataInput.copyWith(email: email);
      isUpload = true;
    }

    if(countryCode != null){
      userDataInput = userDataInput.copyWith(countryCode: countryCode);
      isUpload = true;
    }

    if(phoneNumber != null){
      userDataInput = userDataInput.copyWith(phoneNumber: phoneNumber);
      isUpload = true;
    }

    if(occupation != null){
      userDataInput = userDataInput.copyWith(occupation: occupation);
      isUpload = true;
    }

    if (isUpload){
      print(userDataInput.toJson());
      await setDataBasic(userDataInput);
    }
    settingChanged();
  }
}
