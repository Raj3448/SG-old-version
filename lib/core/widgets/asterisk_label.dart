import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/form_components.dart';

class AsteriskLabel extends StatelessWidget {
  const AsteriskLabel({required this.label, super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextLabel(
          title: label.tr(),
        ),
        Text(
          '*',
          style: AppTextStyle.bodyMediumMedium.copyWith(color: AppColors.error),
        ),
      ],
    );
  }
}
