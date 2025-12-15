import 'package:digimed/app/presentation/pages/info_doctor/admin/controller/state/info_doctor_admin_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resumen_hours_state.freezed.dart';

@freezed
class ResumeHoursState with _$ResumeHoursState{
  factory ResumeHoursState({
    @Default(DoctorDataState.loading()) DoctorDataState doctorDataState,
}) = _ResumeHoursState;
}

