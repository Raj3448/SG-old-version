// ignore_for_file: inference_failure_on_function_invocation, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/widgets/buttons.dart';

class FixedButton extends StatelessWidget {
  const FixedButton({
    required this.ontap,
    required this.btnTitle,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final VoidCallback ontap;
  final String btnTitle;
  final bool showIcon;
  final IconData iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -4),
            blurRadius: 4,
            color: AppColors.black.withOpacity(0.15),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            ontap: ontap,
            title: btnTitle,
            showIcon: showIcon,
            iconPath: iconPath,
            size: ButtonSize.normal,
            type: ButtonType.primary,
            expanded: true,
            iconColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}
