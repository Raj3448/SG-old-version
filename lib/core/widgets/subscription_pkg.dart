// ignore_for_file: deprecated_member_use, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';

enum SubscriptionType { companion, wellness, emergency, inActive }

class SubscriptionPkg extends StatelessWidget {
  const SubscriptionPkg({
    required this.expanded,
    required this.type,
    super.key,
  });

  final bool expanded;
  final SubscriptionType type;

  Color getContainerBorderColor() {
    switch (type) {
      case SubscriptionType.companion:
        return AppColors.warning;
      case SubscriptionType.wellness:
        return AppColors.primary;
      case SubscriptionType.emergency:
        return AppColors.grayscale600;
      case SubscriptionType.inActive:
        return AppColors.line;
    }
  }

  Color getContainerColor() {
    switch (type) {
      case SubscriptionType.companion:
        return AppColors.lightGold;
      case SubscriptionType.wellness:
        return AppColors.secondary;
      case SubscriptionType.emergency:
        return AppColors.grayscale200;
      case SubscriptionType.inActive:
        return AppColors.grayscale200;
    }
  }

  String getLeadingIcon() {
    switch (type) {
      case SubscriptionType.companion:
        return 'assets/icon/companion_genie.svg';
      case SubscriptionType.wellness:
        return 'assets/icon/wellness_genie.svg';
      case SubscriptionType.emergency:
        return 'assets/icon/emergency_genie.svg';
      case SubscriptionType.inActive:
        return '';
    }
  }

  String getPkgName() {
    switch (type) {
      case SubscriptionType.companion:
        return 'Companion Genie';
      case SubscriptionType.wellness:
        return 'Wellness Genie';
      case SubscriptionType.emergency:
        return 'Emergency Genie';
      case SubscriptionType.inActive:
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
        onTap: () {
          if (type == SubscriptionType.companion) {
            GoRouter.of(context).pushNamed(
              RoutesConstants.geniePage,
              pathParameters: {
                'pageTitle': 'Companion Genie',
                'definition':
                    'A dedicated plan in place, focused on remote health monitoring for you and your loved ones.',
                'headline':
                    'We understand the unpredictability of life, but that shouldn’t hinder your well-being. With our comprehensive emergency support service, we’ll ensure holistic care for you. From sickness to health, here are the promises we intend to deliver',
              },
            );
          } else if (type == SubscriptionType.wellness) {
            GoRouter.of(context).pushNamed(
              RoutesConstants.geniePage,
              pathParameters: {
                'pageTitle': 'Wellness Genie',
                'definition':
                    'A dedicated plan in place, focused on remote health monitoring for you and your loved ones.',
                'headline':
                    'We understand the unpredictability of life, but that shouldn’t hinder your well-being. With our comprehensive emergency support service, we’ll ensure holistic care for you. From sickness to health, here are the promises we intend to deliver',
              },
            );
          } else {
            GoRouter.of(context).pushNamed(
              RoutesConstants.geniePage,
              pathParameters: {
                'pageTitle': 'Emergency Genie',
                'definition':
                    'A dedicated plan in place, focused on remote health monitoring for you and your loved ones.',
                'headline':
                    'We understand the unpredictability of life, but that shouldn’t hinder your well-being. With our comprehensive emergency support service, we’ll ensure holistic care for you. From sickness to health, here are the promises we intend to deliver',
              },
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: getContainerColor(),
            border: Border.all(color: getContainerBorderColor()),
            borderRadius: BorderRadius.circular(getContainerBorderRadius()),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SvgPicture.asset(
                  getLeadingIcon(),
                  color: getContainerBorderColor(),
                ),
                const SizedBox(width: 10),
                Text(
                  getPkgName(),
                  style: AppTextStyle.bodyMediumBold.copyWith(
                    color: type == SubscriptionType.emergency
                        ? AppColors.grayscale700
                        : AppColors.grayscale900,
                  ),
                ),
                const Spacer(),
                Icon(
                  AppIcons.arrow_forward,
                  color: getContainerBorderColor(),
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
          border: type == SubscriptionType.companion
              ? Border.all(color: AppColors.warning)
              : Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(getContainerBorderRadius()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            getPkgName(),
            style: AppTextStyle.bodySmallMedium.copyWith(
              color: type == SubscriptionType.inActive
                  ? AppColors.grayscale600
                  : getContainerBorderColor(),
            ),
          ),
        ),
      );
    }
  }
}
