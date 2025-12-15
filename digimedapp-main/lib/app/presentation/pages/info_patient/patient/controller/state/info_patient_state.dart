import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'info_patient_state.freezed.dart';

@freezed
class InfoPatientState with _$InfoPatientState {
  factory InfoPatientState(
      {@Default(false) bool isSetting,
      @Default(false) bool isFetch,
      @Default(false) bool isSettingDataBasic,
      @Default(RequestState.normal()) RequestState requestState,
      @Default(DataPatientState.loaded(null)) DataPatientState dataPatientState,
      @Default(DataDoctorState.loading())
      DataDoctorState dataDoctorState}) = _InfoPatientState;
}

@freezed
class DataPatientState with _$DataPatientState {
  const factory DataPatientState.loading() = DataPatientStateLoading;

  const factory DataPatientState.failed() = DataPatientStateFailed;

  const factory DataPatientState.loaded(Patients? mePatient) =
      DataPatientStateLoaded;
}

@freezed
class DataDoctorState with _$DataDoctorState {
  const factory DataDoctorState.loading() = DataDoctorStateLoading;

  const factory DataDoctorState.failed() = DataDoctorStateFailed;

  const factory DataDoctorState.loaded(Doctor? meDoctor) =
      DataDoctorStateLoaded;
}
