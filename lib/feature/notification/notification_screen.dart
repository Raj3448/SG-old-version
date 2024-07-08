import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/banner_network_img_component.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/notification/model/notification_model.dart';
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
    store.fetchNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PageAppbar(title: 'Notification'),
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
            return Padding(
              padding: const EdgeInsets.all(Dimension.d3),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today',
                      style: AppTextStyle.bodyMediumMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    ...List.generate(store.notifications!.data.length, (index) {
                      return NotificationComponent(
                          notifications: store.notifications!.data[index]);
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
  const NotificationComponent({required this.notifications, super.key});

  final AppNotifications notifications;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Dimension.d2),
      padding: const EdgeInsets.all(Dimension.d3),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        border: Border.all(color: AppColors.grayscale300),
        borderRadius: BorderRadius.circular(Dimension.d2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                notifications.notificationMetaData.title,
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.grayscale900,
                ),
              ),
              const Spacer(),
              Text(
                '12 min ago',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(fontSize: 12, color: AppColors.grayscale700),
              ),
            ],
          ),
          const SizedBox(
            height: Dimension.d2,
          ),
          Text(
            notifications.notificationMetaData.message,
            style: AppTextStyle.bodyMediumMedium
                .copyWith(color: AppColors.grayscale700),
          ),
          if (notifications.notificationMetaData.image.data != null)
            Column(
              children: [
                const SizedBox(
                  height: Dimension.d2,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimension.d2),
                  child: BannerImageComponent(
                    imageUrl: notifications
                        .notificationMetaData.image.data!.attributes.url,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
