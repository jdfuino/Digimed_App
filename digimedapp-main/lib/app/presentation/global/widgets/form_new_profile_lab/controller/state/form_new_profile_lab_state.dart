import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part'form_new_profile_lab_state.freezed.dart';

@freezed
class FormNewProfileLabState with _$FormNewProfileLabState{
  const factory FormNewProfileLabState({
    @Default(false) bool fetching,
    @Default(RequestState.normal())
    RequestState requestState
  }) = _FormNewProfileLabState;
}