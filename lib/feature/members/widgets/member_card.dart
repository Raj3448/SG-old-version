import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/relationship.dart';
import 'package:silver_genie/core/widgets/subscription_plan_tag.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({
    required this.onTap,
    required this.name,
    required this.relation,
    required this.memberDetails,
    required this.imgPath,
    super.key,
  });

  final String name;
  final String relation;
  final Member memberDetails;
  final VoidCallback onTap;
  final String imgPath;

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<ProductListingStore>();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.line),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Avatar.fromSize(imgPath: imgPath, size: AvatarSize.size32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.bodyLargeBold,
                      ),
                      const SizedBox(height: 5),
                      Relationship(
                        relation: relation == 'self' ? 'Self' : relation,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  AppIcons.arrow_forward_ios,
                  color: AppColors.grayscale900,
                  size: 17,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                if (memberDetails.subscriptions != null &&
                    memberDetails.subscriptions!.isNotEmpty)
                  SubscriptionPlanTag(
                    label: memberDetails.subscriptions![0].product.name,
                    iconColorCode: getMetadataValue(
                        store
                                .getProductBasicDetailsById(memberDetails
                                        .subscriptions![0].product.id ??
                                    -1)
                                ?.attributes
                                .metadata ??
                            [],
                        'icon_color_code'),
                    backgroundColorCode: getMetadataValue(
                        store
                                .getProductBasicDetailsById(memberDetails
                                        .subscriptions![0].product.id ??
                                    -1)
                                ?.attributes
                                .metadata ??
                            [],
                        'background_color_code'),
                  ),
                if (memberDetails.subscriptions == null &&
                    memberDetails.subscriptions!.isEmpty)
                  const SubscriptionPlanTag(
                    label: 'In-Active',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
