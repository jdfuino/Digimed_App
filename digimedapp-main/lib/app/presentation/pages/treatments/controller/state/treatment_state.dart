import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/notification_model/notification_model.dart';
import 'package:digimed/app/domain/models/treatment/treatment.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'treatment_state.freezed.dart';

@freezed
class TreatmentState with _$TreatmentState {
  const factory TreatmentState({
    @Default(TreatmentsFetchState.loading())
    TreatmentsFetchState treatmentsFetchState
  }) = _TreatmentState;
}

@freezed
class TreatmentsFetchState with _$TreatmentsFetchState {
  const factory TreatmentsFetchState.loading() =
  TreatmentsFetchStateLoading;

  const factory TreatmentsFetchState.failed(
      HttpRequestFailure failure
      ) = TreatmentsFetchStateFailed;

  const factory TreatmentsFetchState.loaded(
      List<Treatment> treatments,
      ) = TreatmentsFetchStateLoaded;
}