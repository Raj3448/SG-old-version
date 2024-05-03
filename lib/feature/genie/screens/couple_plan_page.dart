import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/custom_drop_down_box.dart';
import 'package:silver_genie/core/widgets/genie_overview.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';

class CouplePlanPage extends StatelessWidget {
  final String pageTitle;
  const CouplePlanPage({required this.pageTitle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(title: pageTitle),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlanPricingDetailsComponent(planName: pageTitle),
              Text(
                '1. Select family member',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(color: AppColors.grayscale700, height: 2),
              ),
              const CustomDropDownBox(
                memberList: ['', ''],
              ),
              Text(
                '2. Select another family member',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(color: AppColors.grayscale700, height: 2),
              ),
              const CustomDropDownBox(
                memberList: ['', ''],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimension.d4),
                child: CustomButton(
                  ontap: () {},
                  title: 'Book care',
                  showIcon: false,
                  iconPath: AppIcons.add,
                  size: ButtonSize.normal,
                  type: ButtonType.disable,
                  expanded: true,
                  iconColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
