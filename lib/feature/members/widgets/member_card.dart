import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/relationship.dart';
import 'package:silver_genie/core/widgets/subscription_pkg.dart';
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
                SubscriptionPkg(
                  expanded: false,
                  type: (memberDetails.subscriptions != null &&
                          memberDetails.subscriptions!.isNotEmpty)
                      ? memberDetails.subscriptions![0].product.name ==
                              'Companion Genie'
                          ? SubscriptionsType.companion
                          : memberDetails.subscriptions![0].product.name ==
                                  'Wellness Genie'
                              ? SubscriptionsType.wellness
                              : memberDetails.subscriptions![0].product.name ==
                                      'Emergency Genie'
                                  ? SubscriptionsType.emergency
                                  : SubscriptionsType.inActive
                      : SubscriptionsType.inActive,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
