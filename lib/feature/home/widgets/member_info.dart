// ignore_for_file: inference_failure_on_function_invocation, lines_longer_than_80_chars

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/coach_contact.dart';
import 'package:silver_genie/core/widgets/inactive_plan.dart';
import 'package:silver_genie/core/widgets/member_creation.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class MemberInfo extends StatefulWidget {
  const MemberInfo({super.key});

  @override
  State<MemberInfo> createState() => MemberInfoState();
}

class MemberInfoState extends State<MemberInfo> {
  @override
  Widget build(BuildContext context) {
    final memberStore = GetIt.I<MembersStore>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Family Members health info'.tr(),
              style: AppTextStyle.bodyXLSemiBold,
            ),
            const SizedBox(height: Dimension.d4),
            Observer(
              builder: (_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast,
                      ),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0;
                              i < memberStore.familyMembers.length;
                              i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  SelectableAvatar(
                                    imgPath: memberStore
                                                .familyMembers[i].profileImg !=
                                            null
                                        ? '${Env.serverUrl}${memberStore.familyMembers[i].profileImg!.url}'
                                        : '',
                                    maxRadius: 24,
                                    isSelected:
                                        memberStore.familyMembers[i].id ==
                                            memberStore.activeMemberId,
                                    ontap: () => memberStore.selectMember(
                                      memberStore.familyMembers[i].id,
                                    ),
                                  ),
                                  const SizedBox(width: Dimension.d4),
                                ],
                              ),
                            ),
                          SelectableAvatar(
                            imgPath: 'assets/icon/44Px.png',
                            maxRadius: 24,
                            isSelected: false,
                            ontap: () {
                              final user =
                                  GetIt.I<UserDetailStore>().userDetails;
                              final member = memberStore.memberById(user!.id);
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
                          ),
                        ],
                      ),
                    ),
                    if (memberStore.selectedIndex != -1)
                      Observer(
                        builder: (context) {
                          final activeMember = memberStore.activeMember;
                          if (activeMember != null &&
                              activeMember.subscriptions!.isNotEmpty) {
                            return ActivePlanComponent(
                              activeMember: activeMember,
                            );
                          }
                          if (activeMember != null &&
                              activeMember.subscriptions!.isEmpty) {
                            return InactivePlanComponent(member: activeMember);
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    Observer(
                      builder: (context) {
                        final activeMember = memberStore.activeMember;
                        if (activeMember != null &&
                            activeMember.subscriptions != null &&
                            activeMember.subscriptions!.isNotEmpty &&
                            activeMember.careCoach != null) {
                          final hasCCFP =
                              activeMember.subscriptions?[0].benefits?.any(
                                    (benefit) =>
                                        benefit.code == 'CCFP' &&
                                        benefit.isActive == true,
                                  ) ??
                                  false;

                          if (hasCCFP) {
                            return Column(
                              children: [
                                const SizedBox(height: Dimension.d4),
                                CoachContact(
                                  imgpath:
                                      '${Env.serverUrl}${activeMember.careCoach?.profileImg?.url ?? ''}',
                                  name:
                                      '${activeMember.careCoach?.firstName ?? ''} ${activeMember.careCoach?.lastName ?? ''}',
                                  phoneNo:
                                      activeMember.careCoach?.contactNo ?? '',
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
