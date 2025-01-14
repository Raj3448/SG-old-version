import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/feature/notification/store/notification_store.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    final userStore = GetIt.I<UserDetailStore>();
    final notificationStore = GetIt.I<NotificationStore>();
    return Observer(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context)
                            .pushNamed(RoutesConstants.userProfileRoute);
                      },
                      child: Avatar(
                        imgPath: userStore.userDetails == null
                            ? ''
                            : userStore.userDetails!.profileImgUrl ?? '',
                        maxRadius: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi',
                            style: AppTextStyle.bodyXLBold.copyWith(
                              color: AppColors.grayscale900,
                              height: 1.4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ).tr(
                            args: [
                              if (userStore.userDetails == null)
                                '----'
                              else
                                userStore.userDetails?.name ?? '---',
                            ],
                          ),
                          Text(
                            'How do you feel today?'.tr(),
                            style: AppTextStyle.bodyMediumMedium.copyWith(
                              color: AppColors.grayscale600,
                              height: 1.42,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Observer(
                      builder: (context) {
                        return _IconContainer(
                          iconPath: notificationStore.isAnyNotifyRemainToRead
                              ? 'assets/icon/bell-Unread.svg'
                              : 'assets/icon/notify-read-bell.svg',
                          onPressed: () {
                            context
                                .pushNamed(RoutesConstants.notificationScreen);
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _IconContainer extends StatelessWidget {
  const _IconContainer({required this.iconPath, required this.onPressed});

  final String iconPath;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 36,
        width: 36,
        decoration: const BoxDecoration(
          color: AppColors.grayscale200,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            height: 20,
          ),
        ),
      ),
    );
  }
}
