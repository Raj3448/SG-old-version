// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: deprecated_member_use, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';

class SubscriptionPkg extends StatelessWidget {
  SubscriptionPkg({
    required this.buttonlabel,
    required this.iconColorCode,
    required this.onTap,
    required this.iconUrl,
    required this.backgroundColorCode,
    super.key,
  });

  final String buttonlabel;
  final String iconColorCode;
  final String backgroundColorCode;
  void Function() onTap;
  final String iconUrl;

  @override
  Widget build(BuildContext context) {
    final backGroundColor = int.tryParse(backgroundColorCode, radix: 16);
    final iconColor = int.tryParse(iconColorCode, radix: 16);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backGroundColor != null
              ? Color(backGroundColor)
              : AppColors.grayscale600,
          border: Border.all(
            color: iconColor != null ? Color(iconColor) : AppColors.gold,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Avatar.fromSize(
                imgPath: '${Env.serverUrl}$iconUrl',
                size: AvatarSize.size12,
                isImageSquare: true,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Text(
                buttonlabel,
                style: AppTextStyle.bodyMediumBold.copyWith(
                  color: AppColors.grayscale900,
                ),
              ),
              const Spacer(),
              Icon(
                AppIcons.arrow_forward,
                color: iconColor != null ? Color(iconColor) : AppColors.gold,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}