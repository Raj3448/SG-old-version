// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';

class CustomDropDownBox extends StatelessWidget {
  final List<String> memberList;
  const CustomDropDownBox({
    required this.memberList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: Dimension.d3, right: Dimension.d6),
      margin: const EdgeInsets.symmetric(vertical: Dimension.d2),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColors.grayscale300),
          borderRadius: BorderRadius.circular(Dimension.d2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Select',
              style: AppTextStyle.bodyLargeMedium.copyWith(height: 2.4)),
          const Icon(
            AppIcons.arrow_down_ios,
            size: 9,
            color: AppColors.grayscale700,
          )
        ],
      ),
    );
  }
}
