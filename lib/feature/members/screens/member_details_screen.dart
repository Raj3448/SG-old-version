// ignore_for_file: lines_longer_than_80_chars, inference_failure_on_function_invocation

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/utils/calculate_age.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/epr_card.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/subscription_pkg.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/members/widgets/subscribe_card.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class MemberDetailsScreen extends StatelessWidget {
  MemberDetailsScreen({
    required this.memberId,
    super.key,
  });

  final int memberId;
  final bool hasCareSub = true;
  final activeMember = GetIt.I<MembersStore>().activeMember;
  @override
  Widget build(BuildContext context) {
    if (activeMember == null) {
      return SafeArea(
        child: Scaffold(
          body: Container(),
        ),
      );
    }
    print('PHR Data of memeber = ${activeMember!.phrModel}');
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const PageAppbar(title: 'Member details'),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FixedButton(
          ontap: () {
            showDialog(
              context: context,
              builder: (context) {
                return const InfoDialog(
                  showIcon: false,
                  title: 'Hi there!!',
                  desc:
                      'In order to update the Health record\nof a family member, please contact\nSilvergenie',
                  btnTitle: 'Contact Genie',
                  showBtnIcon: true,
                  btnIconPath: AppIcons.phone,
                );
              },
            );
          },
          btnTitle: 'Update Health record',
          showIcon: false,
          iconPath: AppIcons.clinical_notes,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic details'.tr(),
                  style: AppTextStyle.bodyXLMedium
                      .copyWith(color: AppColors.grayscale900),
                ),
                const SizedBox(height: 16),
                _BasicDetailsBox(
                  name: [
                    activeMember?.firstName ?? '',
                    activeMember?.lastName ?? '',
                  ].join(' ').trim(),
                  age: '${calculateAge(activeMember!.dateOfBirth)}',
                  gender: activeMember!.gender,
                  relation: activeMember!.relation,
                  mobileNo: activeMember!.phoneNumber,
                  address: activeMember?.fullAddress ?? 'n/a',
                  imgPath: activeMember!.profileImg != null
                      ? '${Env.serverUrl}${activeMember!.profileImg!.url}'
                      : '',
                ),
                const SizedBox(height: 20),
                Text(
                  'Health Records',
                  style: AppTextStyle.bodyXLMedium
                      .copyWith(color: AppColors.grayscale900),
                ),
                const SizedBox(height: 16),
                if (hasCareSub)
                  Column(
                    children: [
                      HealthCard(
                        isEpr: true,
                        dateUpdated: activeMember?.updatedAt == null
                            ? 'n/a'
                            : formatDateTime(activeMember!.updatedAt),
                        ontap: () {
                          GoRouter.of(context).pushNamed(
                            RoutesConstants.eprRoute,
                            pathParameters: {
                              'memberId': '$memberId',
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      if (activeMember!.phrModel != null)
                        HealthCard(
                          isEpr: false,
                          dateUpdated: activeMember?.phrModel?.updatedAt == null
                              ? 'n/a'
                              : formatDateTime(
                                  activeMember!.phrModel!.updatedAt,
                                ),
                          ontap: activeMember!.phrModel == null
                              ? null
                              : () {
                                  GoRouter.of(context).pushNamed(
                                    RoutesConstants.phrPdfViewPage,
                                    pathParameters: {
                                      'memberPhrId':
                                          activeMember!.phrModel!.id.toString(),
                                    },
                                  );
                                },
                        ),
                      const SizedBox(height: Dimension.d17),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SubscribeCard(),
                      const SizedBox(height: Dimension.d8),
                      Text(
                        'Signup for care packages',
                        style: AppTextStyle.bodyXLBold
                            .copyWith(color: AppColors.grayscale900),
                      ),
                      const SizedBox(height: Dimension.d6),
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
                      const SizedBox(height: Dimension.d3),
                      const SizedBox(height: 16),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BasicDetailsBox extends StatelessWidget {
  const _BasicDetailsBox({
    required this.name,
    required this.age,
    required this.gender,
    required this.relation,
    required this.imgPath,
    this.mobileNo,
    this.address,
  });
  final String name;
  final String age;
  final String gender;
  final String? relation;
  final String? mobileNo;
  final String? address;
  final String imgPath;

  @override
  Widget build(BuildContext context) {
    final activeMember = GetIt.I<MembersStore>().activeMember;
    final user = GetIt.I<UserDetailStore>().userDetails;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Avatar.fromSize(imgPath: imgPath, size: AvatarSize.size32),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyle.bodyLargeMedium),
                  const SizedBox(height: Dimension.d2),
                  Row(
                    children: [
                      Text(
                        'Age: $age',
                        style: AppTextStyle.bodyMediumMedium
                            .copyWith(color: AppColors.grayscale600),
                      ),
                      const SizedBox(width: Dimension.d2),
                      Text(
                        'Relationship: $relation',
                        style: AppTextStyle.bodyMediumMedium
                            .copyWith(color: AppColors.grayscale600),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                'Subscription: ',
                style: AppTextStyle.bodyLargeMedium
                    .copyWith(color: AppColors.grayscale700),
              ),
              const SizedBox(width: Dimension.d2),
              const SubscriptionPkg(
                expanded: false,
                type: SubscriptionsType.wellness,
              ),
            ],
          ),
          const SizedBox(height: Dimension.d3),
          if (mobileNo!.isEmpty)
            const SizedBox()
          else
            Row(
              children: [
                const Icon(
                  AppIcons.phone,
                  color: AppColors.grayscale700,
                  size: 17,
                ),
                const SizedBox(width: Dimension.d3),
                Text(
                  mobileNo!,
                  style: AppTextStyle.bodyLargeMedium
                      .copyWith(color: AppColors.grayscale900),
                ),
              ],
            ),
          if (address!.isEmpty)
            const SizedBox()
          else
            Column(
              children: [
                const SizedBox(height: Dimension.d3),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Icon(
                        AppIcons.home,
                        color: AppColors.grayscale700,
                        size: 17,
                      ),
                    ),
                    const SizedBox(width: Dimension.d3),
                    SizedBox(
                      width: 300,
                      child: Text(
                        address!,
                        style: AppTextStyle.bodyLargeMedium
                            .copyWith(color: AppColors.grayscale900),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: Dimension.d3),
          CustomButton(
            ontap: () {
              GoRouter.of(context).pushNamed(
                RoutesConstants.addEditFamilyMemberRoute,
                pathParameters: {
                  'edit': 'true',
                  'isSelf': user!.id == activeMember!.id ? 'true' : 'false',
                },
              );
            },
            title: 'Edit',
            showIcon: false,
            iconPath: AppIcons.add,
            size: ButtonSize.small,
            type: ButtonType.secondary,
            expanded: true,
            iconColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

String formatDateTime(DateTime dateTime) {
  return DateFormat('MM/dd/yyyy').format(dateTime);
}
