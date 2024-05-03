import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/relationship.dart';
import 'package:silver_genie/core/widgets/subscription_pkg.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({
    required this.onTap,
    required this.name,
    required this.relation,
    required this.hasCareSub,
    super.key,
  });

  final String name;
  final String relation;
  final bool hasCareSub;
  final VoidCallback onTap;

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
                Avatar.fromSize(imgPath: '', size: AvatarSize.size32),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyle.bodyLargeBold,
                    ),
                    const SizedBox(height: 5),
                    Relationship(relation: relation),
                  ],
                ),
                const Spacer(),
                const Icon(
                  AppIcons.arrow_forward_ios,
                  color: AppColors.grayscale900,
                  size: 17,
                ),
              ],
            ),
            if (hasCareSub)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  SubscriptionPkg(
                    expanded: false,
                    type: SubscriptionType.wellness,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
