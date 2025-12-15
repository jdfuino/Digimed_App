import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/item_doctors/item_doctors.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'super_admin_home_coordinator_state.freezed.dart';

@freezed
class SuperAdminHomeCoordinatorState with _$SuperAdminHomeCoordinatorState {
  factory SuperAdminHomeCoordinatorState(
      {@Default(ListDoctors.loading())
      ListDoctors listDoctors
      }) = _SuperAdminHomeCoordinatorState;
}

@freezed
class ListDoctors with _$ListDoctors {
  const factory ListDoctors.loading() = ListDoctorsLoading;

  const factory ListDoctors.failed(
      HttpRequestFailure failure,
      ) = ListDoctorsFailed;

  const factory ListDoctors.loaded(
    List<ItemDoctors> list,
  ) = ListDoctorsLoaded;
}
