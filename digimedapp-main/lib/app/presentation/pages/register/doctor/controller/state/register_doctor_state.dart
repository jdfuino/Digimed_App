import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:digimed/app/presentation/pages/info_doctor/admin/controller/state/info_doctor_admin_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_doctor_state.freezed.dart';

@freezed
class RegisterDoctorState with _$RegisterDoctorState {
  factory RegisterDoctorState({
    @Default(true) bool isVisiblePassword,
    @Default(RegisterStepDoctorState.changePassword())
    RegisterStepDoctorState registerStepDoctorState,
    @Default(RequestState.normal())
    RequestState requestState,
    required DoctorData doctorData,
  }) = _RegisterDoctorState;
}

@freezed
class RegisterStepDoctorState with _$RegisterStepDoctorState {
  const factory RegisterStepDoctorState.changePassword() =
      RegisterStepDoctorStateChangePassword;

  const factory RegisterStepDoctorState.changeData() =
      RegisterStepDoctorStateChangeData;

  const factory RegisterStepDoctorState.changeProfileImage() =
      RegisterStepDoctorStateChangeProfileImage;
}

@freezed
class DoctorData with _$DoctorData {
  const factory DoctorData.loading() = DoctorDataLoading;

  const factory DoctorData.faild(
      HttpRequestFailure failure
      ) = DoctorDataFaild;

  const factory DoctorData.sucess({
    required Doctor doctor
  }) = DoctorDataSucess;
}
