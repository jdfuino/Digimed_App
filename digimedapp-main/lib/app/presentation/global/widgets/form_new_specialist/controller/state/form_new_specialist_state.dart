import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/doctor_specialist/doctor_specialist.dart';
import 'package:digimed/app/domain/models/medical_specialty/medical_specialty.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_new_specialist_state.freezed.dart';

@freezed
class FormNewSpecialistbState with _$FormNewSpecialistbState {
  const factory FormNewSpecialistbState(
      {@Default(false) bool fetching,
      @Default(RequestState.normal()) RequestState requestState,
      @Default(MedicalSpecialtyState.loading())
      MedicalSpecialtyState medicalSpecialtyState,
      @Default(AssociateSpecialist.loading())
      AssociateSpecialist associateSpecialist}) = _FormNewSpecialistbState;
}

@freezed
class MedicalSpecialtyState with _$MedicalSpecialtyState {
  const factory MedicalSpecialtyState.loading() = MedicalSpecialtyStateLoading;

  const factory MedicalSpecialtyState.failed(
    HttpRequestFailure failure,
  ) = MedicalSpecialtyStateFailed;

  const factory MedicalSpecialtyState.loaded(
    List<MedicalSpecialty> list,
  ) = MedicalSpecialtyStateLoaded;
}

@freezed
class AssociateSpecialist with _$AssociateSpecialist {
  const factory AssociateSpecialist.loading() = AssociateSpecialistLoading;

  const factory AssociateSpecialist.failed(
    HttpRequestFailure failure,
  ) = AssociateSpecialistFailed;

  const factory AssociateSpecialist.loaded(
    List<DoctorSpecialists> list,
  ) = AssociateSpecialistLoaded;
}
