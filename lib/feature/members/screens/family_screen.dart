// ignore_for_file: inference_failure_on_function_invocation

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/member_creation.dart';
import 'package:silver_genie/feature/home/widgets/no_member.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/members/widgets/member_card.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<MembersStore>()..init();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
        child: Observer(
          builder: (context) {
            if (store.familyMembers.isEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: Dimension.d4),
                    child: Text(
                      'Your Family Members'.tr(),
                      style: AppTextStyle.bodyLargeBold
                          .copyWith(height: 2.4, color: AppColors.grayscale900),
                    ),
                  ),
                  NoMember(
                    ontap: () {
                      final user = GetIt.I<UserDetailStore>().userDetails;
                      final member = store.memberById(user!.id);
                      if (member != null) {
                        context.pushNamed(
                          RoutesConstants.addEditFamilyMemberRoute,
                          pathParameters: {
                            'edit': 'false',
                            'isSelf': 'false',
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return MemberCreation(
                              selfOnTap: () {
                                context.pushNamed(
                                  RoutesConstants.addEditFamilyMemberRoute,
                                  pathParameters: {
                                    'edit': 'false',
                                    'isSelf': 'true',
                                  },
                                );
                              },
                              memberOnTap: () {
                                context.pushNamed(
                                  RoutesConstants.addEditFamilyMemberRoute,
                                  pathParameters: {
                                    'edit': 'false',
                                    'isSelf': 'false',
                                  },
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              );
            } else {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast,
                ),
                child: Observer(
                  builder: (context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimension.d4),
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
                          itemCount: store.familyMembers.length,
                          itemBuilder: (context, index) {
                            final member = store.familyMembers[index];
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
                              imgPath: member.profileImg != null
                                  ? '${Env.serverUrl}${member.profileImg!.url}'
                                  : '',
                            );
                          },
                        ),
                        const SizedBox(height: Dimension.d6),
                        CustomButton(
                          ontap: () {
                            final user = GetIt.I<UserDetailStore>().userDetails;
                            final member = store.memberById(user!.id);
                            if (member != null) {
                              context.pushNamed(
                                RoutesConstants.addEditFamilyMemberRoute,
                                pathParameters: {
                                  'edit': 'false',
                                  'isSelf': 'false',
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return MemberCreation(
                                    selfOnTap: () {
                                      context.pushNamed(
                                        RoutesConstants
                                            .addEditFamilyMemberRoute,
                                        pathParameters: {
                                          'edit': 'false',
                                          'isSelf': 'true',
                                        },
                                      );
                                    },
                                    memberOnTap: () {
                                      context.pushNamed(
                                        RoutesConstants
                                            .addEditFamilyMemberRoute,
                                        pathParameters: {
                                          'edit': 'false',
                                          'isSelf': 'false',
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            }
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
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
