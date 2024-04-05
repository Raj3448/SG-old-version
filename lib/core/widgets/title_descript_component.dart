import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class TitleDescriptComponent extends StatelessWidget {
  final String title;
  final String description;
  const TitleDescriptComponent (
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFC7CFD2), width: 1),
          color: const Color(0xffE3E9EC),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyle.bodyMediumMedium.copyWith(
                color: AppColors.grayscale900,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.46,
              )),
          const SizedBox(
            height: Dimension.d1,
          ),
          Text(description,
              style: AppTextStyle.bodyMediumMedium.copyWith(
                color: AppColors.grayscale700,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.46,
              )),
        ],
      ),
    );
  }
}