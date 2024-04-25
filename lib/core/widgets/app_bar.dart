import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/avatar.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 12),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(RoutesConstants.userProfileRoute);
                },
                child: Avatar.fromSize(
                  imgPath: '',
                  size: AvatarSize.size24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi',
                    style: AppTextStyle.bodyXLBold.copyWith(
                      color: AppColors.grayscale900,
                      height: 1.4,
                    ),
                  ).tr(args: ['Arun']),
                  Text(
                    'How do you feel today?'.tr(),
                    style: AppTextStyle.bodyMediumMedium
                        .copyWith(color: AppColors.grayscale600, height: 1.42),
                  ),
                ],
              ),
              const Spacer(),
              _IconContainer(
                iconPath: 'assets/icon/wallet.svg',
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              _IconContainer(
                iconPath: 'assets/icon/bell-Unread.svg',
                onPressed: () {
                  context.pushNamed(RoutesConstants.notificationScreen);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
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
