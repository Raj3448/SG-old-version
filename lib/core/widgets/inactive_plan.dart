import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/elder_care_sub.dart';

class IconTextComponent extends StatelessWidget {
  const IconTextComponent({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.0),
          child: const Icon(
            AppIcons.check,
            color: AppColors.primary,
            size: Dimension.d2,
          ),
        ),
        const SizedBox(
          width: Dimension.d3,
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.bodyMediumMedium.copyWith(
              color: AppColors.grayscale800,
            ),
          ),
        )
      ],
    );
  }
}

class InactivePlanComponent extends StatelessWidget {
  const InactivePlanComponent({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line, width: 1),
        borderRadius: BorderRadius.circular(Dimension.d2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimension.d3),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: AppTextStyle.bodyLargeBold,
              ),
              ElderCareSubscription(
                  color: ElderCareColor.grey,
                  title: 'Care Inactive',
                  showIcon: false),
            ],
          ),
          const SizedBox(
            height: Dimension.d1,
          ),
          const Row(
            children: [
              AnalogComponent(text1: 'Relation', text2: 'Father'),
              SizedBox(
                width: Dimension.d2,
              ),
              AnalogComponent(text1: 'Age', text2: '62'),
            ],
          ),
          const SizedBox(
            height: Dimension.d3,
          ),
          Container(
            decoration: BoxDecoration(
            color: AppColors.line,
              border: Border.all(
                color: AppColors.secondary,
                width: Dimension.arbitary(1.0),
              ),
              borderRadius: BorderRadius.circular(Dimension.d1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimension.d2, horizontal: Dimension.d3),
              child: Column(
                children: [
                  Text(
                    'Unlock regular health monitoring with our Care Plan',
                    style: AppTextStyle.bodyMediumSemiBold.copyWith(color:AppColors.grayscale900),
                  ),
                  const SizedBox(
                    height: Dimension.d2,
                  ),
                  const IconTextComponent(text: 'Dedicated Coaches'),
                  const SizedBox(
                    height: Dimension.d2,
                  ),
                  const IconTextComponent(text: 'PHR,emergency support',),
                  const SizedBox(
                    height: Dimension.d2,
                  ),
                  const IconTextComponent(text: 'Vital monitoring,and community engagement',)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: Dimension.d3,
          ),
          CustomButton(ontap: (){}, 
          title: 'Upgrade to Care', 
          showIcon: false, 
          iconPath: Icons.not_interested, 
          size: ButtonSize.normal, 
          type: ButtonType.primary, 
          expanded: true),
        ],),
      ),
    );
  }
}
