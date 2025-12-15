import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/coordinador_medical_center/coordinator_medical_center.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'info_medical_center_state.freezed.dart';

@freezed
class InfoMedicalCenterState with _$InfoMedicalCenterState {
  factory InfoMedicalCenterState({
    @Default(RequestState.loading())
    RequestState requestState
  }) = _InfoMedicalCenterState;
}

@freezed
class RequestState with _$RequestState {
  const factory RequestState.loading() = RequestStateLoading;

  const factory RequestState.failed(
      HttpRequestFailure failure,
      ) = RequestStateFailed;

  const factory RequestState.loaded(
    List<User> list,
  ) = RequestStateLoaded;
}