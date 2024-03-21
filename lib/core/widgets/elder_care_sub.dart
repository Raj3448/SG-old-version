import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';

class ElderCareSubBlue extends StatelessWidget {
  const ElderCareSubBlue({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              AppIcons.elderly_person,
              color: AppColors.primary,
            ),
            const SizedBox(width: 5),
            Text(
              'Elder care subscription',
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.primary),
            ),
            const SizedBox(width: 5),
            const Icon(
              AppIcons.check,
              size: 12,
              color: AppColors.primary,
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}

class ElderCareSubGreen extends StatelessWidget {
  const ElderCareSubGreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE6F9F0),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              AppIcons.elderly_person,
              color: AppColors.success,
            ),
            const SizedBox(width: 5),
            Text(
              'Elder care subscription',
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.success),
            ),
            const SizedBox(width: 5),
            const Icon(
              AppIcons.check,
              size: 12,
              color: AppColors.success,
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
