import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

enum ChipType {
  success,
  failed,
  pending,
  refund,
  unpaid,
}

class CustomChip extends StatelessWidget {
  const CustomChip({
    required this.chipType,
    super.key,
  });
  final ChipType chipType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: _getWidth(),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          _getText(),
          textAlign: TextAlign.center,
          style: AppTextStyle.bodySmallMedium.copyWith(color: _getTextColor()),
        ),
      ),
    );
  }

  String _getText() {
    switch (chipType) {
      case ChipType.success:
        return 'Success';
      case ChipType.failed:
        return 'Failed';
      case ChipType.pending:
        return 'Pending';
      case ChipType.refund:
        return 'Refund';
      case ChipType.unpaid:
        return 'Unpaid';
    }
  }

  Color _getBackgroundColor() {
    switch (chipType) {
      case ChipType.success:
        return AppColors.lightGreen;
      case ChipType.failed:
        return AppColors.lightRed;
      case ChipType.pending:
        return AppColors.lightOrange;
      case ChipType.refund:
        return AppColors.lightYellow;
      case ChipType.unpaid:
        return AppColors.lightBlue;
    }
  }

  Color _getTextColor() {
    switch (chipType) {
      case ChipType.success:
        return AppColors.success;
      case ChipType.failed:
        return AppColors.error;
      case ChipType.pending:
        return AppColors.warning2;
      case ChipType.refund:
        return AppColors.warning;
      case ChipType.unpaid:
        return AppColors.primary;
    }
  }

  double _getWidth() {
    switch (chipType) {
      case ChipType.success:
        return 80;
      case ChipType.failed:
        return 67;
      case ChipType.pending:
        return 79;
      case ChipType.refund || ChipType.unpaid:
        return 73;
    }
  }
}
