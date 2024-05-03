import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';

class HealthCard extends StatelessWidget {
  const HealthCard({
    required this.isEpr,
    required this.dateUpdated,
    required this.ontap,
    super.key,
  });

  final bool isEpr;
  final String dateUpdated;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grayscale100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEpr
                ? 'Emergency Patient Record (EPR)'
                : 'Patient Health Record (PHR)',
            style: AppTextStyle.bodyLargeMedium,
          ),
          const SizedBox(
            height: Dimension.d3,
          ),
          Row(
            children: [
              Text(
                'Last updated : ',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(color: AppColors.grayscale600),
              ),
              const SizedBox(width: Dimension.d2),
              Text(
                dateUpdated,
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(color: AppColors.grayscale600),
              ),
            ],
          ),
          const SizedBox(
            height: Dimension.d3,
          ),
          CustomButton(
            ontap: ontap,
            title: isEpr ? 'View EPR' : 'View PHR',
            showIcon: true,
            iconPath: AppIcons.visibility_on,
            size: ButtonSize.small,
            type: ButtonType.secondary,
            expanded: false,
          ),
        ],
      ),
    );
  }
}
