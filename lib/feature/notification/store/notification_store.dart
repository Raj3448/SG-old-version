// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/notification/model/notification_model.dart';
import 'package:silver_genie/feature/notification/services/notification_service.dart';

part 'notification_store.g.dart';

class NotificationStore = _NotificationStoreBase with _$NotificationStore;

abstract class _NotificationStoreBase with Store {
  _NotificationStoreBase(
    this.notificationsServices,
  );
  final INotificationFacade notificationsServices;

  @observable
  NotificationModel? notifications;

  @observable
  String? notificationfailure;

  @observable
  bool isNotificationLoading = false;

  @observable
  bool notificationsLoaded = false;

  @action
  void fetchNotifications() {
    if (notificationsLoaded) {
      return;
    }
    isNotificationLoading = true;
    notificationsServices.fetchNotification().then((response) {
      response.fold((l) {
        l.maybeMap(
          socketError: (value) => notificationfailure = 'No Internet',
          orElse: () => notificationfailure = 'Something went wrong',
        );
      }, (r) {
        notifications = r;
        notificationsLoaded = true;
      });
      isNotificationLoading = false;
    });
  }
}
