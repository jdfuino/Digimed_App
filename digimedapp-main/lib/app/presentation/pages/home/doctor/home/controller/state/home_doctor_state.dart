import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_doctor_state.freezed.dart';

@freezed
class HomeDoctorState with _$HomeDoctorState{
  factory HomeDoctorState({
    @Default(AssociateDoctorPatients.loading())
    AssociateDoctorPatients associatePatients
  }) = _HomeDoctorState;
}

@freezed
class AssociateDoctorPatients with _$AssociateDoctorPatients{
  const factory AssociateDoctorPatients.loading() = AssociateDoctorPatientsLoading;

  const factory AssociateDoctorPatients.failed() = AssociateDoctorPatientsFailed;

  const factory AssociateDoctorPatients.loaded(
      List<Patients>? list,
      ) = AssociateDoctorPatientsLoaded;
}