import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class Relationship extends StatelessWidget {
  const Relationship({required this.relation, super.key});
  final String relation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          // 'Relationship: '.tr(),
          'Relationship : ',
          style: AppTextStyle.bodyMediumMedium
              .copyWith(color: AppColors.grayscale700),
        ),
        Text(
          // relation.tr(),
          relation,
          style: AppTextStyle.bodyMediumMedium
              .copyWith(color: AppColors.grayscale700),
        ),
      ],
    );
  }
}
