// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class SubscriptionPlanTag extends StatelessWidget {
  const SubscriptionPlanTag({
    required this.label,
    this.iconColorCode,
    this.backgroundColorCode,
    Key? key,
  }) : super(key: key);
  final String label;
  final String? iconColorCode;
  final String? backgroundColorCode;

  @override
  Widget build(BuildContext context) {
    final backGroundColor = int.tryParse(backgroundColorCode ?? 'z1', radix: 16);
    final iconColor = int.tryParse(iconColorCode ?? 'z1', radix: 16);
    return Container(
      decoration: BoxDecoration(
        color: backGroundColor == null ? AppColors.grayscale200 : Color(backGroundColor),
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          label,
          style: AppTextStyle.bodySmallMedium.copyWith(
            color: iconColor == null
                ? AppColors.grayscale600
                : Color(iconColor),
          ),
        ),
      ),
    );
  }
}
