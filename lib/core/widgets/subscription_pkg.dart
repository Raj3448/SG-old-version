// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: deprecated_member_use, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/avatar.dart';

enum SubscriptionsType { companion, wellness, emergency, inActive }

class SubscriptionPkg extends StatelessWidget {
  SubscriptionPkg({
    required this.expanded,
    required this.type,
    this.buttonlabel,
    this.iconColorCode,
    this.onTap,
    this.iconUrl,
    this.backgroundColorCode,
    Key? key,
  }) : super(key: key);

  final bool expanded;
  final SubscriptionsType type;
  final String? buttonlabel;
  final String? iconColorCode;
  final String? backgroundColorCode;
  void Function()? onTap;
  final String? iconUrl;

  Color getContainerBorderColor() {
    switch (type) {
      case SubscriptionsType.companion:
        return AppColors.warning;
      case SubscriptionsType.wellness:
        return AppColors.primary;
      case SubscriptionsType.emergency:
        return AppColors.grayscale600;
      case SubscriptionsType.inActive:
        return AppColors.line;
    }
  }

  Color getContainerColor() {
    switch (type) {
      case SubscriptionsType.companion:
        return AppColors.lightGold;
      case SubscriptionsType.wellness:
        return AppColors.secondary;
      case SubscriptionsType.emergency:
        return AppColors.grayscale200;
      case SubscriptionsType.inActive:
        return AppColors.grayscale200;
    }
  }

  String getLeadingIcon() {
    switch (type) {
      case SubscriptionsType.companion:
        return 'assets/icon/companion_genie.svg';
      case SubscriptionsType.wellness:
        return 'assets/icon/wellness_genie.svg';
      case SubscriptionsType.emergency:
        return 'assets/icon/emergency_genie.svg';
      case SubscriptionsType.inActive:
        return '';
    }
  }

  String getPkgName() {
    switch (type) {
      case SubscriptionsType.companion:
        return 'Companion Genie';
      case SubscriptionsType.wellness:
        return 'Wellness Genie';
      case SubscriptionsType.emergency:
        return 'Emergency Genie';
      case SubscriptionsType.inActive:
        return 'In-Active';
    }
  }

  double getContainerHeight() {
    return expanded ? 48 : 28;
  }

  double getContainerBorderRadius() {
    return expanded ? 8 : 4;
  }

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return GestureDetector(
        onTap: onTap ??
            () {
              if (type == SubscriptionsType.companion) {
                GoRouter.of(context).pushNamed(
                  RoutesConstants.geniePage,
                  pathParameters: {
                    'pageTitle': 'Companion Genie',
                    'defination':
                        'A dedicated plan in place, focused on remote health monitoring for you and your loved ones.',
                    'headline':
                        'We understand the unpredictability of life, but that shouldn’t hinder your well-being. With our comprehensive emergency support service, we’ll ensure holistic care for you. From sickness to health, here are the promises we intend to deliver',
                    // 'subscriptionsType':
                    //     SubscriptionsType.emergency.toString().split('.').last,
                  },
                );
              } else if (type == SubscriptionsType.wellness) {
                // GoRouter.of(context).pushNamed(
                //   RoutesConstants.geniePage,
                //   pathParameters: {
                //     'pageTitle': 'Wellness Genie',
                //     'defination':
                //         'A dedicated plan in place, focused on remote health monitoring for you and your loved ones.',
                //     'headline':
                //         'We understand the unpredictability of life, but that shouldn’t hinder your well-being. With our comprehensive emergency support service, we’ll ensure holistic care for you. From sickness to health, here are the promises we intend to deliver',
                //     // 'subscriptionsType':
                //     //     SubscriptionsType.wellness.toString().split('.').last,
                //   },
                // );
              } else {
                // GoRouter.of(context).pushNamed(
                //   RoutesConstants.geniePage,
                //   pathParameters: {
                //     'pageTitle': 'Emergency Genie',
                //     'defination':
                //         'A dedicated plan in place, focused on remote health monitoring for you and your loved ones.',
                //     'headline':
                //         'We understand the unpredictability of life, but that shouldn’t hinder your well-being. With our comprehensive emergency support service, we’ll ensure holistic care for you. From sickness to health, here are the promises we intend to deliver',
                //     // 'subscriptionsType':
                //     //     SubscriptionsType.emergency.toString().split('.').last,
                //   },
                // );
              }
            },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColorCode != null
                ? Color(int.parse(backgroundColorCode!, radix: 16))
                : getContainerColor(),
            border: Border.all(
                color: iconColorCode != null
                    ? Color(int.parse(iconColorCode!, radix: 16))
                    : getContainerBorderColor()),
            borderRadius: BorderRadius.circular(getContainerBorderRadius()),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (iconUrl != null)
                  Avatar.fromSize(
                    imgPath: '${Env.serverUrl}${iconUrl!}',
                    size: AvatarSize.size12,
                    isImageSquare: true,
                    fit: BoxFit.contain,
                  )
                else
                  SvgPicture.asset(
                    getLeadingIcon(),
                    color: getContainerBorderColor(),
                  ),
                const SizedBox(width: 10),
                Text(
                  buttonlabel ?? getPkgName(),
                  style: AppTextStyle.bodyMediumBold.copyWith(
                    color: type == SubscriptionsType.emergency
                        ? AppColors.grayscale700
                        : AppColors.grayscale900,
                  ),
                ),
                const Spacer(),
                Icon(
                  AppIcons.arrow_forward,
                  color: iconColorCode != null
                      ? Color(int.parse(iconColorCode!, radix: 16))
                      : getContainerBorderColor(),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: getContainerColor(),
          border: type == SubscriptionsType.companion
              ? Border.all(color: AppColors.warning)
              : Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(getContainerBorderRadius()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            getPkgName(),
            style: AppTextStyle.bodySmallMedium.copyWith(
              color: type == SubscriptionsType.inActive
                  ? AppColors.grayscale600
                  : getContainerBorderColor(),
            ),
          ),
        ),
      );
    }
  }
}
