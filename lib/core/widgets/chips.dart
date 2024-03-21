import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

class SuccessChip extends StatelessWidget {
  const SuccessChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F9F0),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          'Success',
          style:
              AppTextStyle.bodyMediumMedium.copyWith(color: AppColors.success),
        ),
      ),
    );
  }
}

class FailedChip extends StatelessWidget {
  const FailedChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 67,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDED),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          'Failed',
          style: AppTextStyle.bodyMediumMedium.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}

class PendingChip extends StatelessWidget {
  const PendingChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 79,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2ED),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          'Pending',
          style:
              AppTextStyle.bodyMediumMedium.copyWith(color: AppColors.warning2),
        ),
      ),
    );
  }
}

class RefundChip extends StatelessWidget {
  const RefundChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 73,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAE8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          'Refund',
          style:
              AppTextStyle.bodyMediumMedium.copyWith(color: AppColors.warning),
        ),
      ),
    );
  }
}

class UnpaidChip extends StatelessWidget {
  const UnpaidChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 73,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F0FF),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          'Unpaid',
          style:
              AppTextStyle.bodyMediumMedium.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
