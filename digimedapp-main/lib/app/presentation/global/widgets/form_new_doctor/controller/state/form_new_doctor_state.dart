import 'package:freezed_annotation/freezed_annotation.dart';

part'form_new_doctor_state.freezed.dart';

@freezed
class FormNewDoctorState with _$FormNewDoctorState{
  const factory FormNewDoctorState({
    @Default(null) DateTime? dateTime,
    @Default(null) String? gender,
    @Default(null) String? fullName,
    @Default(null) String? idNumber,
    @Default(null) String? email,
    @Default(null) String? phoneNumber,
    @Default(null) String? occupation,
    @Default(null) String? imgProfile,
    @Default(false) bool fetching,
    @Default(RequestState.normal())
    RequestState requestState
}) = _FormNewDoctor;
}

@freezed
class RequestState with _$RequestState {
  const factory RequestState.fetch() = RequestStateFetch;

  const factory RequestState.normal() = RequestStateNormal;
}