import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/banner_network_img_component.dart';
import 'package:silver_genie/core/widgets/empty_state_component.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/notification/model/notification_model.dart';
import 'package:silver_genie/feature/notification/services/notification_service.dart';
import 'package:silver_genie/feature/notification/store/notification_store.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final store = GetIt.I<NotificationStore>();

  @override
  void initState() {
    store.refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PageAppbar(title: 'Notification'.tr()),
        backgroundColor: AppColors.white,
        body: Observer(
          builder: (context) {
            if (store.isNotificationLoading) {
              return const Center(
                child: LoadingWidget(
                  showShadow: false,
                ),
              );
            }
            if (store.notificationfailure != null ||
                !store.notificationsLoaded) {
              store.notificationfailure = null;
              return const ErrorStateComponent(
                  errorType: ErrorType.somethinWentWrong);
            }

            if (store.getTodayNotifications.isEmpty &&
                store.getEarlierNotifications.isEmpty) {
              return Center(
                  child: EmptyStateComponent(
                emptyDescription: "You haven't any notification yet.".tr(),
              ));
            }

            return Padding(
              padding: const EdgeInsets.all(Dimension.d3),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (store.getTodayNotifications.isNotEmpty)
                      Text(
                        'Today'.tr(),
                        style: AppTextStyle.bodyMediumMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ...List.generate(store.getTodayNotifications.length,
                        (index) {
                      return NotificationComponent(
                          notification: store.getTodayNotifications[index]);
                    }),
                    if (store.getEarlierNotifications.isNotEmpty)
                      Text(
                        'Earlier'.tr(),
                        style: AppTextStyle.bodyMediumMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ...List.generate(store.getEarlierNotifications.length,
                        (index) {
                      return NotificationComponent(
                          notification: store.getEarlierNotifications[index]);
                    }),
                    const SizedBox(
                      height: Dimension.d3,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationComponent extends StatelessWidget {
  NotificationComponent({required this.notification, super.key});

  final AppNotifications notification;
  final service = GetIt.I<NotificationServices>();
  final store = GetIt.I<NotificationStore>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!notification.notificationMetaData.read) {
          service
              .markToReadById(notificationId: notification.id.toString())
              .then((response) {
            response.fold((l) {}, (r) {
              store.refresh();
            });
          });
        }
        final cnd1 = notification.notificationMetaData.actionType == 'openPage';
        final cnd2 = notification.notificationMetaData.actionUrl != '/' &&
            notification.notificationMetaData.actionUrl !=
                '/notificationScreen';
        if (cnd1 && cnd2) {
          if (notification.notificationMetaData.additionalData.isEmpty) {
            context.push(
              notification.notificationMetaData.actionUrl,
            );
          } else {
            context.push(notification.notificationMetaData.actionUrl);
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Dimension.d2),
        padding: const EdgeInsets.all(Dimension.d3),
        decoration: BoxDecoration(
          color: notification.notificationMetaData.read
              ? AppColors.grayscale100
              : AppColors.secondary,
          border: Border.all(color: AppColors.grayscale300),
          borderRadius: BorderRadius.circular(Dimension.d2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    notification.notificationMetaData.title,
                    style: AppTextStyle.bodyMediumMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grayscale900,
                    ),
                  ),
                ),
                const SizedBox(
                  width: Dimension.d2,
                ),
                Text(
                  notificationFormatDateTime(
                      notification.notificationMetaData.createdAt.toLocal()),
                  style: AppTextStyle.bodyMediumMedium
                      .copyWith(fontSize: 12, color: AppColors.grayscale700),
                ),
              ],
            ),
            const SizedBox(
              height: Dimension.d2,
            ),
            Text(
              notification.notificationMetaData.message,
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale700),
            ),
            if (notification.notificationMetaData.image.data != null)
              Column(
                children: [
                  const SizedBox(
                    height: Dimension.d2,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimension.d2),
                    child: BannerImageComponent(
                      imageUrl: notification
                          .notificationMetaData.image.data!.attributes.url,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

String notificationFormatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hr ago';
  } else {
    return DateFormat('d MMM yyyy, h:mm a').format(dateTime);
  }
}
