import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shome/report/notification.dart';

import '../../main.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  init(){
    notifications = logBox.values.toList();
    constants.put('notifBadge', notifications.length);

    mainController.updateMain(); //for delete badge
    emit(NotificationInitial());
  }
  clear() {
    logBox.clear();
    notifications.clear();
    emit(NotificationInitial());
  }
}
