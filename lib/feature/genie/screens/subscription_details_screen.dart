// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/utils/calculate_age.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/plan_display_component.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';

class SubscriptionDetailsScreen extends StatelessWidget {
  SubscriptionDetailsScreen({
    required this.price,
    required this.subscriptionData,
    required this.isCouple,
    super.key,
  });

  final String price;
  final SubscriptionData subscriptionData;
  final bool isCouple;

  final memberStore = GetIt.I<MembersStore>();

  Price getPriceById(SubscriptionData subscriptionData, int id) {
    final price = subscriptionData.product.prices.firstWhere(
      (price) => price.id == id,
    );

    return price;
  }

  String getFormattedFamilyMembers(List<int> ids) {
    var names = <String>[];
    for (final id in ids) {
      final member = memberStore.findMemberById(id);
      if (member != null) {
        names.add(member.name);
      }
    }
    if (names.isEmpty) {
      return '';
    }
    if (names.length > 2) {
      names = names.sublist(0, 2);
    }
    if (names.length > 1) {
      return names.join(' & ');
    }

    return names.first;
  }

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
              Text(
                isCouple
                    ? 'Companion plan (Couple)'
                    : 'Companion plan (Single)',
                style: AppTextStyle.bodyXLMedium,
              ),
              const SizedBox(height: Dimension.d6),
              const Text(
                'Details',
                style: AppTextStyle.bodyLargeMedium,
              ),
              const SizedBox(height: Dimension.d4),
              _DetailsBox(
                serviceOptedFor:
                    getFormattedFamilyMembers(subscriptionData.familyMemberIds),
                duration:
                    '${getPriceById(subscriptionData, subscriptionData.priceId).recurringIntervalCount} ${removeLastLy(
                  getPriceById(subscriptionData, subscriptionData.priceId)
                      .recurringInterval!,
                )}',
                startDate: formatDate(subscriptionData.startDate),
                renewalDate: formatDate(subscriptionData.expiresOn),
              ),
              const SizedBox(height: Dimension.d4),
              const Divider(color: AppColors.line),
              const SizedBox(height: Dimension.d4),
              const Text(
                'Payment details',
                style: AppTextStyle.bodyLargeMedium,
              ),
              const SizedBox(height: Dimension.d3),
              _PaymentTile(
                title: 'Subscription cost',
                value:
                    '₹ ${getPriceById(subscriptionData, subscriptionData.priceId).unitAmount}',
              ),
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
                    '₹ ${getPriceById(subscriptionData, subscriptionData.priceId).unitAmount}',
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
  });

  final String serviceOptedFor;
  final String duration;
  final String startDate;
  final String renewalDate;

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
