import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class NoteComponent extends StatelessWidget {
  const NoteComponent({required this.desc});

  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Note',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(color: AppColors.grayscale900),
              ),
              const SizedBox(width: Dimension.d1),
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppColors.grayscale900,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: AppTextStyle.bodyMediumMedium
                .copyWith(color: AppColors.grayscale800),
          ),
        ],
      ),
    );
  }
}