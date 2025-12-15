import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/notification_model/notification_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inbox_state.freezed.dart';

@freezed
class InboxState with _$InboxState {
  const factory InboxState({
    @Default(NotificationState.loading())
    NotificationState notificationState
  }) = _InboxState;
}

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState.loading() =
  NotificationStateLoading;

  const factory NotificationState.failed(
      HttpRequestFailure failure
      ) = NotificationStateFailed;

  const factory NotificationState.loaded(
      List<NotificationModel> notifications,
      ) = NotificationStateLoaded;
}