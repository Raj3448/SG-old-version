import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class AssigningComponent extends StatelessWidget {
  const AssigningComponent({
    required this.name,
    required this.initializeElement,
    super.key,
  });

  final String name;
  final String initializeElement;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            name,
            style: AppTextStyle.bodyMediumMedium
                .copyWith(height: 1.5, color: AppColors.grayscale900),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ': ',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(height: 2, color: AppColors.grayscale900),
              ),
              Expanded(
                child: Text(
                  initializeElement,
                  style: AppTextStyle.bodyMediumMedium
                      .copyWith(height: 2, color: AppColors.grayscale700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
