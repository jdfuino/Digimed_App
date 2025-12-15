import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_doctor_super_admin_state.freezed.dart';


@freezed
class HomeDoctorSuperAdminState with _$HomeDoctorSuperAdminState{
  factory HomeDoctorSuperAdminState({
    @Default(AssociatePatients.loading())
    AssociatePatients associatePatientState
}) = _HomeDoctorSuperAdminState;
}

@freezed
class AssociatePatients with _$AssociatePatients{
  const factory AssociatePatients.loading() = AssociatePatientsLoading;

  const factory AssociatePatients.failed() = AssociatePatientsFailed;

  const factory AssociatePatients.loaded(
      List<Patients>? list,
      ) = AssociatePatientsLoaded;
}