import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';

enum ElderCareColor { blue, green }

class ElderCareSubscription extends StatelessWidget {
  const ElderCareSubscription({required this.color, super.key});

  final ElderCareColor color;

  Color _getIconColor() {
    switch (color) {
      case ElderCareColor.blue:
        return AppColors.primary;
      case ElderCareColor.green:
        return AppColors.success;
    }
  }

  Color _getBackgroundColor() {
    switch (color) {
      case ElderCareColor.blue:
        return AppColors.secondary;
      case ElderCareColor.green:
        return const Color(0xFFE6F9F0);
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
              'Elder care subscription'.tr(),
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: _getIconColor()),
            ),
            const SizedBox(width: 5),
            Icon(
              AppIcons.check,
              size: 12,
              color: _getIconColor(),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
