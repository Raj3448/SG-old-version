import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';

class ProfileNav extends StatelessWidget {
  const ProfileNav({required this.title, required this.onTap, super.key});

  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                style: AppTextStyle.bodyLargeMedium.copyWith(
                  color: AppColors.grayscale900,
                ),
              ),
              const Icon(
                AppIcons.arrow_forward_ios,
                color: AppColors.grayscale700,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
