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
  bool isNotificationRefreshLoading = false;

  @observable
  String? notificationRefreshFailure;

  @observable
  NotificationModel? notifications;

  @observable
  String? notificationfailure;

  @observable
  bool isNotificationLoading = false;

  @observable
  bool notificationsLoaded = false;

  @computed
  List<AppNotifications> get getTodayNotifications => notifications != null
      ? notifications!.data
          .where(
            (element) =>
                !_isNotification24Ago(element.notificationMetaData.createdAt),
          )
          .toList()
      : [];

  @computed
  bool get isAnyNotifyRemainToRead {
    if (notifications != null) {
      return notifications!.data
          .any((element) => !element.notificationMetaData.read);
    }
    return false;
  }

  @computed
  List<AppNotifications> get getEarlierNotifications => notifications != null
      ? notifications!.data
          .where(
            (element) =>
                _isNotification24Ago(element.notificationMetaData.createdAt),
          )
          .toList()
      : [];

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

  @action
  void refresh() {
    isNotificationRefreshLoading = true;
    notificationsServices.fetchNotification().then((response) {
      response.fold((l) {
        l.maybeMap(
          socketError: (value) => notificationRefreshFailure = 'No Internet',
          orElse: () => notificationRefreshFailure = 'Something went wrong',
        );
      }, (r) {
        notifications = r;
        notificationsLoaded = true;
      });
      isNotificationRefreshLoading = false;
    });
  }

  bool _isNotification24Ago(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours >= 24;
  }

  void clear() {
    notifications = null;
  }
}
