import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_doctor_admin_state.freezed.dart';

@freezed
class HomeDoctorAdminState with _$HomeDoctorAdminState{
  factory HomeDoctorAdminState({
    @Default(AssociatePatients.loading())
    AssociatePatients associatePatients
}) = _HomeDoctorAdminState;
}

@freezed
class AssociatePatients with _$AssociatePatients{
  const factory AssociatePatients.loading() = AssociatePatientsLoading;

  const factory AssociatePatients.failed() = AssociatePatientsFailed;

  const factory AssociatePatients.loaded(
      List<Patients>? list,
      ) = AssociatePatientsLoaded;
}