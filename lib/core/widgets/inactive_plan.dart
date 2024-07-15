// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/utils/calculate_age.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/subscription_pkg.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';

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
  InactivePlanComponent({required this.member, super.key});
  final store = GetIt.I<ProductListingStore>();
  Member member;

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
                  member.name,
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
            Row(
              children: [
                AnalogComponent(label: 'Relation', value: member.relation),
                const SizedBox(
                  width: Dimension.d2,
                ),
                AnalogComponent(
                  label: 'Age',
                  value: calculateAge(member.dateOfBirth).toString(),
                ),
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
                productBasicDetailsList: store
                    .getProdListRankOrder(store.getSubscriptActiveProdList),
                isUpgradeable: false,
              ),
          ],
        ),
      ),
    );
  }
}

class ProductListingCareComponent extends StatelessWidget {
  final List<ProductBasicDetailsModel> productBasicDetailsList;
  final bool isUpgradeable;

  ProductListingCareComponent({
    required this.productBasicDetailsList,
    required this.isUpgradeable,
    super.key,
  });

  final memberStore = GetIt.I<MembersStore>();

  SubscriptionsType _getSubscriptionType(String name) {
    switch (name) {
      case 'Companion Genie':
        return SubscriptionsType.companion;
      case 'Wellness Genie':
        return SubscriptionsType.wellness;
      default:
        return SubscriptionsType.emergency;
    }
  }

  List<Widget> _buildBtnWidgetList(BuildContext context) {
    return productBasicDetailsList.map((product) {
      return Padding(
        padding: const EdgeInsets.only(top: Dimension.d3),
        child: SubscriptionPkg(
          expanded: true,
          type: _getSubscriptionType(product.attributes.name),
          buttonlabel: product.attributes.name,
          iconColorCode:
              getMetadataValue(product.attributes.metadata, 'icon_color_code'),
          backgroundColorCode: getMetadataValue(
            product.attributes.metadata,
            'background_color_code',
          ),
          iconUrl: product.attributes.icon.data.attributes.url,
          onTap: () {
            GoRouter.of(context).pushNamed(
              RoutesConstants.geniePage,
              pathParameters: {
                'pageTitle': product.attributes.name,
                'id': product.id.toString(),
                'isUpgradeable': isUpgradeable.toString(),
                'activeMemberId': '${memberStore.activeMemberId}',
              },
            );
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildBtnWidgetList(context),
    );
  }
}
  String getMetadataValue(List<Metadatum> metadata, String key) {
    return metadata
        .firstWhere(
          (element) => element.key == key,
          orElse: () => Metadatum(id: 1, key: key, value: 'FFFDFDFD'),
        )
        .value;
  }