// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
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
                SubscriptionPkg(
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
            if (store.getSubscriptActiveProdList.isNotEmpty)
              Text(
                'Signup to Personalized care packages',
                style: AppTextStyle.bodyMediumBold
                    .copyWith(color: AppColors.grayscale900),
              ),
            if (store.getSubscriptActiveProdList.isNotEmpty)
              ProductListingCareComponent(
                productBasicDetailsList: store.getSubscriptActiveProdList,
                isUpgradable: false,
              )
          ],
        ),
      ),
    );
  }
}

class ProductListingCareComponent extends StatelessWidget {
  final List<ProductBasicDetailsModel> productBasicDetailsList;
  final bool isUpgradable;
  ProductListingCareComponent({
    required this.productBasicDetailsList,
    required this.isUpgradable,
    Key? key,
  }) : super(key: key);

  List<Widget> btnWidgetList = [];
  void initializeWidget(BuildContext context) {
    btnWidgetList = List.generate(
        productBasicDetailsList.length,
        (index) => Padding(
              padding: const EdgeInsets.only(top: Dimension.d2),
              child: SubscriptionPkg(
                expanded: true,
                type: productBasicDetailsList[index].attributes.name == 'Companion Genie' ? SubscriptionsType.companion: productBasicDetailsList[index].attributes.name == 'Wellness Genie'? SubscriptionsType.wellness : SubscriptionsType.emergency,
                buttonlabel: productBasicDetailsList[index].attributes.name,
                colorCode: productBasicDetailsList[index]
                    .attributes
                    .metadata
                    .first
                    .value,
                iconUrl: productBasicDetailsList[index]
                    .attributes
                    .icon
                    .data
                    .attributes
                    .url,
                onTap: () {
                  GoRouter.of(context).pushNamed(
                    RoutesConstants.geniePage,
                    pathParameters: {
                      'pageTitle':
                          productBasicDetailsList[index].attributes.name,
                      'id': productBasicDetailsList[index].id.toString(),
                      'isUpgradble': isUpgradable.toString()
                    },
                  );
                },
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    initializeWidget(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...btnWidgetList],
    );
  }
}
