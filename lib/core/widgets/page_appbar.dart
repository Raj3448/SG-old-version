import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';

class PageAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PageAppbar({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: AppColors.white,
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: const Icon(
                AppIcons.arrow_backward,
                color: AppColors.grayscale900,
                size: 18,
              ),
            ),
            const SizedBox(width: 16),
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
