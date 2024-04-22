import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';

enum ElderCareColor { blue, green, grey }

class ElderCareSubscription extends StatelessWidget {
  const ElderCareSubscription({
    required this.color,
    required this.title,
    required this.showIcon,
    super.key,
  });

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
        return AppColors.lightGreen;
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
        padding: const EdgeInsets.all(Dimension.d1),
        child: Row(
          children: [
            Icon(
              AppIcons.elderly_person,
              color: _getIconColor(),
              size: Dimension.d3,
            ),
            const SizedBox(width: 5),
            Text(
              title.tr(),
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: _getIconColor(), fontSize: 14),
            ),
            const SizedBox(width: 5),
            if (showIcon)
              Icon(
                AppIcons.check,
                size: 12,
                color: _getIconColor(),
              )
            else
              const SizedBox(),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
