import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/notification/model/notification_model.dart';
import 'package:silver_genie/feature/notification/store/notification_store.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<NotificationStore>();
    store.fetchNotifications();
    return Observer(
      builder: (context) {
        return Scaffold(
          appBar: const PageAppbar(title: 'Notification'),
          body: store.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(Dimension.d3),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today',
                          style: AppTextStyle.bodyMediumMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: store.notifications!
                                  .fold((l) => null, (r) => r.length),
                              itemBuilder: (context, index) {
                                if (index == 3) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Earlier',
                                        style: AppTextStyle.bodyMediumMedium
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primary),
                                      ),
                                      NotificationComponent(
                                          notificationModel:
                                              store.notifications!.fold(
                                                  (l) => NotificationModel(
                                                      title: '',
                                                      description: '',
                                                      datetime: DateTime.now()),
                                                  (r) {
                                        return r[index];
                                      }))
                                    ],
                                  );
                                }
                                return NotificationComponent(
                                    notificationModel: store.notifications!
                                        .fold(
                                            (l) => NotificationModel(
                                                title: '',
                                                description: '',
                                                datetime: DateTime.now()), (r) {
                                  return r[index];
                                }));
                              }),
                        ),
                        const SizedBox(
                          height: Dimension.d20,
                        )
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class NotificationComponent extends StatelessWidget {
  const NotificationComponent({required this.notificationModel, super.key});

  final NotificationModel notificationModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Dimension.d2),
      padding: const EdgeInsets.all(Dimension.d3),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        border: Border.all(width: 1, color: AppColors.grayscale300),
        borderRadius: BorderRadius.circular(Dimension.d2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(notificationModel.title,
                  style: AppTextStyle.bodyMediumMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grayscale900)),
              const Spacer(),
              Text('12 min ago',
                  style: AppTextStyle.bodyMediumMedium
                      .copyWith(fontSize: 12, color: AppColors.grayscale700))
            ],
          ),
          const SizedBox(
            height: Dimension.d2,
          ),
          Text(notificationModel.description,
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale700)),
          if (notificationModel.imageUrl != null)
            Column(
              children: [
                const SizedBox(
                  height: Dimension.d2,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimension.d2),
                  child: Image.asset(
                    notificationModel.imageUrl!,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
