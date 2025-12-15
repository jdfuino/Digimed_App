import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/activity/activity.dart';
import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scored_activity_state.freezed.dart';

@freezed
class ScoredActivityState with _$ScoredActivityState{
  factory ScoredActivityState({
    @Default(ActivityDataState.loading())
    ActivityDataState activityDataState,
  }) = _ScoredActivityState;
}

@freezed
class ActivityDataState with _$ActivityDataState{
  const factory ActivityDataState.loading() = ActivityDataStateLoading;

  const factory ActivityDataState.failed(
      HttpRequestFailure failed
      ) = ActivityDataStateFailed;

  const factory ActivityDataState.loaded(
       List<Activity> list) = ActivityDataStateLoaded;
}