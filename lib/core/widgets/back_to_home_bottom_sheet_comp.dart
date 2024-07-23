// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/back_to_home_component.dart';

class BackToHomeBottomSheetComp extends StatelessWidget {
  const BackToHomeBottomSheetComp({
    required this.sheetname,
    required this.title,
    required this.description,
    super.key,
  });
  final String sheetname;

  final String title;

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimension.d2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sheetname,
            style: AppTextStyle.bodyXLMedium.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 2.8,
            ),
          ),
          BackToHomeComponent(title: title, description: description),
        ],
      ),
    );
  }
}
