import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/doctor_user_points_hours/doctor_user_points_hours.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'info_doctor_super_admin_state.freezed.dart';

@freezed
class InfoDoctorSuperAdminState with _$InfoDoctorSuperAdminState {
  factory InfoDoctorSuperAdminState({
    @Default(false) bool isSetting,
    @Default(null) String? email,
    @Default(null) String? codeCountry,
    @Default(null) String? phoneNumber,
    @Default(null) String? occupation,
    @Default(SettingInfoState.normal()) SettingInfoState settingInfoState,
    @Default(DoctorDataInfoState.loading()) DoctorDataInfoState doctorDataInfoState,
    @Default(RequestState.normal())
    RequestState requestState
  }) = _InfoDoctorSuperAdminState;
}

@freezed
class SettingInfoState with _$SettingInfoState{
  const factory SettingInfoState.loading() = SettingInfoStateLoading;
  const factory SettingInfoState.normal() = SettingInfoStateNormal;
  const factory SettingInfoState.setting() = SettingInfoStateSetting;
}

@freezed
class DoctorDataInfoState with _$DoctorDataInfoState {
  const factory DoctorDataInfoState.loading() = DoctorDataInfoStateLoading;

  const factory DoctorDataInfoState.faild(
      HttpRequestFailure failure
      ) = DoctorDataInfoStateFaild;

  const factory DoctorDataInfoState.sucess({
    required User user,
    required DoctorUserPointsHours doctorUserPointsHours,
    List<WorkingHours>? list,
  }) = DoctorDataInfoStateSucess;
}
