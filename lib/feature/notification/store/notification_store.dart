// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/failure/failure.dart';
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
  Either<Failure, List<NotificationModel>>? notifications;

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchNotifications() async {
    isLoading = true;
    notifications = await notificationsServices.fetchNotification();
    isLoading = false;
  }
}
