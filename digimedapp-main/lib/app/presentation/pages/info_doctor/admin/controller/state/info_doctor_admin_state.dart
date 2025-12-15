import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/doctor_user_points_hours/doctor_user_points_hours.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'info_doctor_admin_state.freezed.dart';

@freezed
class InfoDoctorAdminState with _$InfoDoctorAdminState {
  factory InfoDoctorAdminState({
    @Default(false) bool isSetting,
    @Default(null) String? email,
    @Default(null) String? codeCountry,
    @Default(null) String? phoneNumber,
    @Default(null) String? occupation,
    @Default(SettingState.normal()) SettingState settingState,
    @Default(DoctorDataState.loading()) DoctorDataState doctorDataState,
    @Default(RequestState.normal())
    RequestState requestState
  }) = _InfoDoctorAdminState;
}

@freezed
class SettingState with _$SettingState{
  const factory SettingState.loading() = SettingStateLoading;
  const factory SettingState.normal() = SettingStateNormal;
  const factory SettingState.setting() = SettingStateSetting;
}

@freezed
class DoctorDataState with _$DoctorDataState {
  const factory DoctorDataState.loading() = DoctorDataStateLoading;

  const factory DoctorDataState.faild(
      HttpRequestFailure failure
      ) = DoctorDataStateFaild;

  const factory DoctorDataState.sucess({
    required User user,
    required DoctorUserPointsHours doctorUserPointsHours,
    List<WorkingHours>? list,
  }) = DoctorDataStateSucess;
}
