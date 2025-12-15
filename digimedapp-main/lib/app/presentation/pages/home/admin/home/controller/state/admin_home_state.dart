import 'package:digimed/app/data/http/http.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/item_doctors/item_doctors.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_home_state.freezed.dart';

@freezed
class AdminHomeState with _$AdminHomeState {
  factory AdminHomeState(
      {@Default(AssociateDoctors.loading())
      AssociateDoctors associateDoctors
      }) = _AdminHomeState;
}

@freezed
class AssociateDoctors with _$AssociateDoctors {
  const factory AssociateDoctors.loading() = AssociateDoctorsLoading;

  const factory AssociateDoctors.failed(
      HttpRequestFailure failure,
      ) = AssociateDoctorsFailed;

  const factory AssociateDoctors.loaded(
    List<ItemDoctors> list,
  ) = AssociateDoctorsLoaded;
}
