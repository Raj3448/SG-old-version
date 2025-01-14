import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/utils/launch_dialer.dart';
import 'package:silver_genie/core/widgets/avatar.dart';

class CoachContact extends StatelessWidget {
  const CoachContact({
    required this.imgpath,
    required this.name,
    required this.phoneNo,
    super.key,
  });

  final String imgpath;
  final String name;
  final String phoneNo;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.line,
        ),
        borderRadius: BorderRadius.circular(Dimension.d2),
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
                const SizedBox(width: Dimension.d2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180,
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.bodyLargeSemiBold,
                      ),
                    ),
                    const SizedBox(height: Dimension.d1),
                    Text(
                      'Health coach',
                      style: AppTextStyle.bodyMediumMedium
                          .copyWith(color: AppColors.grayscale700),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                await launchDialer('+91$phoneNo');
              },
              child: Row(
                children: [
                  const Icon(
                    AppIcons.phone,
                    color: AppColors.primary,
                    size: Dimension.d5,
                  ),
                  const SizedBox(width: Dimension.d2),
                  Text(
                    'Call',
                    style: AppTextStyle.bodyLargeSemiBold
                        .copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(width: Dimension.d3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
