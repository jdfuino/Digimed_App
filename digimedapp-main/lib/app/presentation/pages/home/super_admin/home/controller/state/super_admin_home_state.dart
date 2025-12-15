import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/medical_center/medical_center.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'super_admin_home_state.freezed.dart';

@freezed
class SuperAdminHomeState with _$SuperAdminHomeState {
  factory SuperAdminHomeState(
      {@Default(MedicalCenterState.loading())
      MedicalCenterState medicalCenterState
      }) = _SuperAdminHomeState;
}

@freezed
class MedicalCenterState with _$MedicalCenterState {
  const factory MedicalCenterState.loading() = MedicalCenterStateLoading;

  const factory MedicalCenterState.failed(
      HttpRequestFailure failure,
      ) = MedicalCenterStateFailed;

  const factory MedicalCenterState.loaded(
    List<MedicalCenter> list,
  ) = MedicalCenterStateLoaded;
}
