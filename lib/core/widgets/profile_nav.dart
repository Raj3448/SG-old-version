import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';

class ProfileNav extends StatelessWidget {
  const ProfileNav({required this.title, super.key});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimension.d12,
      decoration: const BoxDecoration(
        color: AppColors.grayscale100,
        border: Border(
          bottom: BorderSide(
            color: AppColors.grayscale300,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimension.d3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyle.bodyLargeMedium,
            ),
            const Icon(AppIcons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
