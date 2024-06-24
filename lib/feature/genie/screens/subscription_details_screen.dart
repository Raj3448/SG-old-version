import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';

class SubscriptionDetailsScreen extends StatelessWidget {
  const SubscriptionDetailsScreen({required this.price, super.key});

  final String price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PageAppbar(title: 'Book subscription'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FixedButton(
        ontap: () {},
        btnTitle: 'Proceed to Pay',
        showIcon: false,
        iconPath: AppIcons.add,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Companion plan (Couple)',
                style: AppTextStyle.bodyXLMedium,
              ),
              const SizedBox(height: Dimension.d6),
              const Text(
                'Details',
                style: AppTextStyle.bodyLargeMedium,
              ),
              const SizedBox(height: Dimension.d4),
              const _DetailsBox(
                serviceOptedFor: 'Amanjot Singh & Amanj S',
                duration: '2 months',
                startDate: '11/06/2024',
                renewalDate: '11/12/2024',
                automaticRenewal: false,
              ),
              const SizedBox(height: Dimension.d4),
              const Divider(color: AppColors.line),
              const SizedBox(height: Dimension.d4),
              const Text(
                'Payment details',
                style: AppTextStyle.bodyLargeMedium,
              ),
              const SizedBox(height: Dimension.d3),
              _PaymentTile(title: 'Subscription cost', value: price),
              const SizedBox(height: Dimension.d3),
              const _PaymentTile(title: 'Others', value: '-'),
              const SizedBox(height: Dimension.d4),
              const Divider(color: AppColors.line),
              const SizedBox(height: Dimension.d4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total to pay',
                    style: AppTextStyle.bodyXLMedium,
                  ),
                  Text(
                    price,
                    style: AppTextStyle.bodyLargeMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsBox extends StatelessWidget {
  const _DetailsBox({
    required this.serviceOptedFor,
    required this.duration,
    required this.startDate,
    required this.renewalDate,
    required this.automaticRenewal,
  });

  final String serviceOptedFor;
  final String duration;
  final String startDate;
  final String renewalDate;
  final bool automaticRenewal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpandedAnalogComponent(
          label: 'Service opted for',
          value: serviceOptedFor,
        ),
        const SizedBox(height: Dimension.d3),
        ExpandedAnalogComponent(label: 'Duration of service', value: duration),
        const SizedBox(height: Dimension.d3),
        ExpandedAnalogComponent(label: 'Plan start date', value: startDate),
        const SizedBox(height: Dimension.d3),
        ExpandedAnalogComponent(label: 'Next renewal date', value: renewalDate),
        const SizedBox(height: Dimension.d3),
        ExpandedAnalogComponent(
          label: 'Automatic renewal',
          value: automaticRenewal.toString() == 'true' ? 'On' : 'Off',
        ),
      ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyle.bodyMediumMedium),
        Text(value, style: AppTextStyle.bodyMediumMedium),
      ],
    );
  }
}
