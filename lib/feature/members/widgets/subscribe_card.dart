// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';

class SubscribeCard extends StatelessWidget {
  const SubscribeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Sorry, No Available health records for\nthis family member. To create EPR &\nPHR please subscribe to Silvergenie's\nElder care",
            textAlign: TextAlign.center,
            style: AppTextStyle.bodyLargeMedium.copyWith(
              color: AppColors.grayscale700,
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            ontap: () {},
            title: 'Subscribe',
            showIcon: false,
            iconPath: AppIcons.add,
            size: ButtonSize.normal,
            type: ButtonType.primary,
            expanded: true,
            iconColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}

class PlanDetailsCard extends StatelessWidget {
  const PlanDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grayscale100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SG Wellness plan (Elder care)',
            style: AppTextStyle.bodyXLBold,
          ),
          const SizedBox(height: 16),
          Text(
            'A dedicated plan in place, focused on remote health monitoring for you and your loved ones',
            style: AppTextStyle.bodyLargeMedium
                .copyWith(color: AppColors.grayscale800),
          ),
          const SizedBox(height: 16),
          Text(
            'Benefits',
            style:
                AppTextStyle.bodyXLBold.copyWith(color: AppColors.grayscale900),
          ),
          const SizedBox(height: 16),
          const _BenefitTile(
            text: 'Dedicated SilverGenie digital relationship manager.',
          ),
          const SizedBox(height: 12),
          const _BenefitTile(
            text: 'Multiple body vital monitoring.',
          ),
          const SizedBox(height: 12),
          const _BenefitTile(
            text: '1 free general physician consultation.',
          ),
          const SizedBox(height: 12),
          const _BenefitTile(
            text:
                'Access to SilverGenie community engagement program & activities.',
          ),
          const SizedBox(height: 12),
          const _BenefitTile(
            text: 'Access to health and wellness webinars, & expert speaks.',
          ),
          const SizedBox(height: 12),
          const _BenefitTile(
            text:
                'Creation, updation & continuous analysis of Personal Health Record (PHR).',
          ),
          const SizedBox(height: 12),
          const _BenefitTile(
            text: 'Concierge network connect, coordination & support.',
          ),
        ],
      ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  const _BenefitTile({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icon/success.svg',
          height: 20,
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.75,
          child: Text(
            text,
            softWrap: true,
            style: AppTextStyle.bodyMediumMedium.copyWith(
              color: AppColors.grayscale800,
            ),
          ),
        ),
      ],
    );
  }
}
