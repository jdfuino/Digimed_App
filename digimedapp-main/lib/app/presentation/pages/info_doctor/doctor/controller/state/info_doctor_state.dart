import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'info_doctor_state.freezed.dart';

@freezed
class InfoDoctorState with _$InfoDoctorState {
  factory InfoDoctorState({
    @Default(false) bool isSetting,
    @Default(null) String? email,
    @Default(null) String? codeCountry,
    @Default(null) String? phoneNumber,
    @Default(null) String? occupation,
    @Default(SettingDoctorState.normal()) SettingDoctorState settingDoctorState,
    @Default(MyDoctorDataState.loading()) MyDoctorDataState myDoctorDataState,
    @Default(RequestState.normal())
    RequestState requestState
  }) = _InfoDoctorState;
}

@freezed
class SettingDoctorState with _$SettingDoctorState{
  const factory SettingDoctorState.loading() = SettingDoctorStateLoading;
  const factory SettingDoctorState.normal() = SettingDoctorStateNormal;
  const factory SettingDoctorState.setting() = SettingDoctorStateSetting;
}

@freezed
class MyDoctorDataState with _$MyDoctorDataState {
  const factory MyDoctorDataState.loading() = MyDoctorDataStateLoading;

  const factory MyDoctorDataState.faild(
      HttpRequestFailure failure
      ) = MyDoctorDataStateFaild;

  const factory MyDoctorDataState.sucess({
    required User user,
    List<WorkingHours>? list,
  }) = MyDoctorDataStateSucess;
}