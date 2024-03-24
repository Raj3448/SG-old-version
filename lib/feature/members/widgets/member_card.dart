import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/elder_care_sub.dart';
import 'package:silver_genie/core/widgets/relationship.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({
    required this.name,
    required this.relation,
    required this.hasCareSub,
    super.key,
  });

  final String name;
  final String relation;
  final bool hasCareSub;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              children: [
                SizedBox(height: 8),
                ElderCareSubscription(color: ElderCareColor.blue),
              ],
            ),
        ],
      ),
    );
  }
}
