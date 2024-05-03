import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class TitleDescriptComponent extends StatelessWidget {
  const TitleDescriptComponent({
    required this.title,
    required this.description,
    super.key,
  });
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: Dimension.d2),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.grayscale400, width: 1),
          color: AppColors.grayscale300,
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.bodyMediumMedium.copyWith(
              color: AppColors.grayscale900,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.46,
            ),
          ),
          const SizedBox(
            height: Dimension.d1,
          ),
          Text(
            description,
            style: AppTextStyle.bodyMediumMedium.copyWith(
              color: AppColors.grayscale700,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 1.46,
            ),
          ),
        ],
      ),
    );
  }
}
