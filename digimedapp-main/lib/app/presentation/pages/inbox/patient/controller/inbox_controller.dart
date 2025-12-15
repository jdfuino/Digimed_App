import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/inbox/patient/controller/state/inbox_state.dart';

class InboxController extends StateNotifier<InboxState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;

  InboxController(super._state,
      {required this.accountRepository, required this.sessionController});


  Future<void> onRefresh({NotificationState? notificationState}) async {
    if (notificationState == null) {
      state =
          state.copyWith(notificationState: const NotificationStateLoading());
    }

    final result = await accountRepository.getUserData();

    if (result == null) {
      state =
          state.copyWith(notificationState: const NotificationStateLoaded([]));
      return;
    }

    state = state.copyWith(
        notificationState: NotificationStateLoaded(result.notifications));
  }

  Future<void> markAsRead(int id) async {
    try {
      logger.i("Marking notification $id as read");
      final response = await accountRepository.markReadNotification(id);
      response.when(left: (_){}, right: (value){
        if(value != null && value){
          final currentState = state.notificationState;
          if (currentState is NotificationStateLoaded) {
            final updatedNotifications = currentState.notifications.map((notification) {
              if (notification.id == id) {
                return notification.copyWith(read: true);
              }
              return notification;
            }).toList();
            state = state.copyWith(notificationState: NotificationStateLoaded(updatedNotifications));
          }
        }
      });
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
