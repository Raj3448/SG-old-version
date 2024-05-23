import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/members/widgets/member_card.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<MembersStore>();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Family Members'.tr(),
                style: AppTextStyle.bodyLargeBold,
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: Dimension.d3);
                },
                itemCount: store.members.length,
                itemBuilder: (context, index) {
                  final member = store.members[index];
                  return MemberCard(
                    onTap: () {
                      store.selectMember(member.id);
                      context.pushNamed(
                        RoutesConstants.memberDetailsRoute,
                        pathParameters: {
                          'memberId': '${member.id}',
                        },
                      );
                    },
                    name: '${member.firstName} ${member.lastName}',
                    relation: member.relation ?? 'Self',
                    hasCareSub: true,
                  );
                },
              ),
              const SizedBox(height: Dimension.d6),
              CustomButton(
                ontap: () {
                  context.pushNamed(
                    RoutesConstants.addEditFamilyMemberRoute,
                    pathParameters: {'edit': 'false'},
                  );
                },
                title: 'Add new member',
                showIcon: false,
                iconPath: AppIcons.add,
                size: ButtonSize.normal,
                type: ButtonType.primary,
                expanded: true,
                iconColor: AppColors.white,
              ),
              const SizedBox(height: Dimension.d6),
            ],
          ),
        ),
      ),
    );
  }
}
