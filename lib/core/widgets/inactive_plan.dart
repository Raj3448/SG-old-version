// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/subscription_pkg.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';

class IconTextComponent extends StatelessWidget {
  const IconTextComponent({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(
            AppIcons.check,
            color: AppColors.primary,
            size: Dimension.d2,
          ),
        ),
        const SizedBox(
          width: Dimension.d3,
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.bodyMediumMedium.copyWith(
              color: AppColors.grayscale800,
            ),
          ),
        ),
      ],
    );
  }
}

class InactivePlanComponent extends StatelessWidget {
  InactivePlanComponent({required this.name, super.key});
  final store = GetIt.I<ProductListingStore>();
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(Dimension.d2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimension.d3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: AppTextStyle.bodyLargeBold,
                ),
                const SubscriptionPkg(
                  expanded: false,
                  type: SubscriptionsType.inActive,
                ),
              ],
            ),
            const SizedBox(
              height: Dimension.d1,
            ),
            const Row(
              children: [
                AnalogComponent(text1: 'Relation', text2: 'Mother'),
                SizedBox(
                  width: Dimension.d2,
                ),
                AnalogComponent(text1: 'Age', text2: '65'),
              ],
            ),
            const SizedBox(height: Dimension.d3),
            if (store.productBasicDetailsModelList != null)
              _SignupPersonalizedCareComponent(productBasicDetailsList: store.productBasicDetailsModelList!,)
          ],
        ),
      ),
    );
  }
}

class _SignupPersonalizedCareComponent extends StatelessWidget {
  final List<ProductBasicDetailsModel> productBasicDetailsList;
  const _SignupPersonalizedCareComponent({
    required this.productBasicDetailsList, Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Signup to Personalized care packages',
          style: AppTextStyle.bodyMediumBold
              .copyWith(color: AppColors.grayscale900),
        ),
        const SizedBox(height: Dimension.d3),
        const SubscriptionPkg(
          expanded: true,
          type: SubscriptionsType.companion,
        ),
        const SizedBox(height: Dimension.d3),
        const SubscriptionPkg(
          expanded: true,
          type: SubscriptionsType.wellness,
        ),
        const SizedBox(height: Dimension.d3),
        const SubscriptionPkg(
          expanded: true,
          type: SubscriptionsType.emergency,
        ),
      ],
    );
  }
}
