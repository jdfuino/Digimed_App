import 'package:digimed/app/presentation/pages/scored_activity/patient/controller/state/scored_activity_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scroed_activity_doctor_state.freezed.dart';

@freezed
class ScoredActivityDoctorState with _$ScoredActivityDoctorState{
  factory ScoredActivityDoctorState({
    @Default(ActivityDataState.loading())
    ActivityDataState activityDataState,
  }) = _ScoredActivityDoctorState;
}