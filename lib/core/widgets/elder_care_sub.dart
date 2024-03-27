import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';

enum ElderCareColor { blue, green, grey }

class ElderCareSubscription extends StatelessWidget {
  const ElderCareSubscription({
    required this.color,
    required this.title,
    required this.showIcon, 
    super.key});

  final ElderCareColor color;
  final String title;
  final bool showIcon;

  Color _getIconColor() {
    switch (color) {
      case ElderCareColor.blue:
        return AppColors.primary;
      case ElderCareColor.green:
        return AppColors.success;
      case ElderCareColor.grey:
        return AppColors.grayscale600;
    }
  }

  Color _getBackgroundColor() {
    switch (color) {
      case ElderCareColor.blue:
        return AppColors.secondary;
      case ElderCareColor.green:
        return const Color(0xFFE6F9F0);
      case ElderCareColor.grey:
        return AppColors.grayscale200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(
              AppIcons.elderly_person,
              color: _getIconColor(),
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: _getIconColor()),
            ),
            const SizedBox(width: 5),
            showIcon?Icon(
              AppIcons.check,
              size: 12,
              color: _getIconColor(),
            ):SizedBox(),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
