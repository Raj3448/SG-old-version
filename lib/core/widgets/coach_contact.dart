import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';

class CoachContact extends StatelessWidget {
  const CoachContact({
    required this.imgpath,
    required this.name,
    super.key,
  });

  final String imgpath;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.line,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(Dimension.d2)
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimension.d3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Avatar(
                  imgPath: imgpath,
                  maxRadius: 24,
                ),
                const SizedBox(
                  width: Dimension.d2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyle.bodyLargeSemiBold,
                    ),
                    const SizedBox(
                      height: Dimension.d1,
                    ),
                    Text(
                      'Health coach',
                      style: AppTextStyle.bodyMediumMedium.copyWith(color: AppColors.grayscale700)
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  AppIcons.phone,
                  color: AppColors.primary,
                  size: Dimension.d4,
                ),
                const SizedBox(
                  width: Dimension.d1,
                ),
                Text(
                  'Call',
                  style: AppTextStyle.bodyLargeSemiBold
                      .copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
