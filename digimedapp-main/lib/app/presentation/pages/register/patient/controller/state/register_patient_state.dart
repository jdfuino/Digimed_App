import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/state/home_patient_admin_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_patient_state.freezed.dart';

@freezed
class RegisterPatientState with _$RegisterPatientState {
  factory RegisterPatientState({
    @Default(true) bool isVisiblePassword,
    @Default(RegisterStepPatientState.changePassword())
    RegisterStepPatientState registerStepPatientState,
    @Default(PatientState.loading())
    PatientState patientState,
    @Default(RequestState.normal())
    RequestState requestState
  }) = _RegisterPatientState;
}

@freezed
class RegisterStepPatientState with _$RegisterStepPatientState {
  const factory RegisterStepPatientState.changePassword() =
  RegisterStepPatientStateChangePassword;

  const factory RegisterStepPatientState.changeData() =
  RegisterStepPatientStateChangeData;

  const factory RegisterStepPatientState.changePathology() =
  RegisterStepPatientStateChangePathology;

  const factory RegisterStepPatientState.changeFamilyPathology() =
  RegisterStepPatientStateChangeFamilyPathology;

  const factory RegisterStepPatientState.changeHabit() =
  RegisterStepPatientStateChangeHabit;

  const factory RegisterStepPatientState.changeFood() =
  RegisterStepPatientStateChangeFood;

  const factory RegisterStepPatientState.changeEnv() =
  RegisterStepPatientStateChangeEnv;

  const factory RegisterStepPatientState.changeFollowed() =
  RegisterStepPatientStateChangeFollowed;

  const factory RegisterStepPatientState.changeProfileImage() =
  RegisterStepPatientStateChangeProfileImage;

  const factory RegisterStepPatientState.newProfileCardiovascular() =
  RegisterStepPatientStateNewProfileCardiovascular;
}