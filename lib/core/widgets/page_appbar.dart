import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';

class PageAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PageAppbar({required this.title, this.onTap, super.key});
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: AppColors.black.withOpacity(0.12),
          ),
        ],
      ),
      child: AppBar(
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: onTap ?? () {
                GoRouter.of(context).pop();
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                padding: const EdgeInsets.all(15),
                child: const Icon(
                  AppIcons.arrow_backward,
                  color: AppColors.grayscale900,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: AppTextStyle.bodyXLMedium.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
