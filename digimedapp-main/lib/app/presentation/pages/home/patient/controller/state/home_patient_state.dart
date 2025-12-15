import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_patient_state.freezed.dart';

@freezed
class HomePatientState with _$HomePatientState{
  factory HomePatientState({
    @Default(AssociatePatientPatients.loading())
    AssociatePatientPatients associatePatients
  }) = _HomePatientState;
}

@freezed
class AssociatePatientPatients with _$AssociatePatientPatients{
  const factory AssociatePatientPatients.loading() = AssociatePatientPatientsLoading;

  const factory AssociatePatientPatients.failed() = AssociatePatientPatientsFailed;

  const factory AssociatePatientPatients.loaded(
      Patients? mePatient,
      ) = AssociatePatientPatientsLoaded;
}