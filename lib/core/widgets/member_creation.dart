import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';

class MemberCreation extends StatelessWidget {
  const MemberCreation({
    required this.selfOnTap,
    required this.memberOnTap,
    super.key,
  });

  final VoidCallback selfOnTap;
  final VoidCallback memberOnTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: AppColors.white,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Member Creation', style: AppTextStyle.bodyXLBold),
            const SizedBox(height: Dimension.d2),
            const Text(
              'Select for whom you want to create',
              style: AppTextStyle.bodyLargeMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimension.d6),
            CustomButton(
              ontap: selfOnTap,
              title: 'For Self',
              showIcon: false,
              iconPath: AppIcons.add,
              size: ButtonSize.normal,
              type: ButtonType.secondary,
              expanded: true,
              iconColor: AppColors.primary,
            ),
            const SizedBox(height: Dimension.d4),
            CustomButton(
              ontap: memberOnTap,
              title: 'New family Member',
              showIcon: false,
              iconPath: AppIcons.add,
              size: ButtonSize.normal,
              type: ButtonType.secondary,
              expanded: true,
              iconColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
