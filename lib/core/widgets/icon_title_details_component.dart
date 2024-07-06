import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class IconTitleDetailsComponent extends StatelessWidget {
  const IconTitleDetailsComponent({
    required this.icon,
    required this.title,
    required this.details,
    this.detailsTextOverflow = TextOverflow.ellipsis,
    super.key,
  });
  final IconData icon;
  final String title;
  final String details;
  final TextOverflow? detailsTextOverflow;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          icon,
          size: 22,
          color: AppColors.grayscale700,
        ),
        const SizedBox(width: Dimension.d2),
        Text(
          title,
          style: AppTextStyle.bodyLargeMedium
              .copyWith(color: AppColors.grayscale600),
        ),
        const SizedBox(width: Dimension.d4),
        Expanded(
          child: Text(
            details,
            textAlign: TextAlign.end,
            style: AppTextStyle.bodyLargeMedium.copyWith(
                color: AppColors.grayscale900, overflow: detailsTextOverflow),
          ),
        ),
      ],
    );
  }
}
