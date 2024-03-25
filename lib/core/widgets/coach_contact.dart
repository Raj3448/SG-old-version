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
    return Padding(
      padding: const EdgeInsets.all(Dimension.d3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Avatar(
                imgPath: imgpath,
                maxRadius: 36,
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
                  const Text(
                    'Health coach',
                    style: AppTextStyle.bodyMediumMedium,
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
    );
  }
}
