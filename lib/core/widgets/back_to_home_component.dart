// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';

class BackToHomeComponent extends StatelessWidget {
  final String title;
  final String description;
  final bool showDesc;

  const BackToHomeComponent({
    required this.title,
    required this.description,
    required this.showDesc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icon/success.svg',
          height: 92,
        ),
        const SizedBox(height: Dimension.d4),
        Text(
          title,
          style: AppTextStyle.bodyLargeBold
              .copyWith(color: AppColors.grayscale900),
        ),
        const SizedBox(height: Dimension.d2),
        if (showDesc)
          Text(
            description,
            style: AppTextStyle.bodyMediumMedium.copyWith(
              color: AppColors.grayscale700,
            ),
          )
        else
          const SizedBox(),
        const SizedBox(height: Dimension.d6),
        CustomButton(
          ontap: () {
            context.pop();
          },
          title: 'Back to Home',
          showIcon: false,
          iconPath: AppIcons.add,
          size: ButtonSize.normal,
          type: ButtonType.primary,
          expanded: true,
          iconColor: AppColors.primary,
        ),
      ],
    );
  }
}
