import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

enum SelectorType {
  withBorder,
  withoutBorder,
  withBgColor,
}

class Selector extends StatelessWidget {
  const Selector({
    required this.icon,
    required this.title,
    required this.selectorType,
    required this.iconColor,
    required this.textColor,
    required this.ontap,
    super.key,
  });

  final IconData icon;
  final String title;
  final SelectorType selectorType;
  final Color iconColor;
  final Color textColor;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: InkWell(
        onTap: ontap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 296,
          decoration: _buildDecoration(),
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 19,
                color: iconColor,
              ),
              const SizedBox(width: 17),
              Text(
                title,
                style: AppTextStyle.bodyLargeMedium.copyWith(
                  height: 1.5,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    switch (selectorType) {
      case SelectorType.withBorder:
        return BoxDecoration(
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(8),
        );
      case SelectorType.withoutBorder:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        );
      case SelectorType.withBgColor:
        return BoxDecoration(
          color: AppColors.grayscale200,
          borderRadius: BorderRadius.circular(8),
        );
    }
  }
}
