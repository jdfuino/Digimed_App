import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_state.freezed.dart';

@freezed
class ChangePasswordState with _$ChangePasswordState {
  factory ChangePasswordState({
    @Default(true) bool isVisiblePassword,
    @Default(false) bool fetching,
    @Default(RequestState.normal())
    RequestState requestState,
  }) = _ChangePasswordState;
}
