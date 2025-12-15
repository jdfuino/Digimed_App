import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part'form_new_patient_state.freezed.dart';

@freezed
class FormNewPatientState with _$FormNewPatientState{
  const factory FormNewPatientState({
    @Default(null) String? gender,
    @Default(false) bool fetching,
    @Default(null) String? imgProfile,
    @Default(RequestState.normal())
    RequestState requestState
  }) = _FormNewPatientState;
}