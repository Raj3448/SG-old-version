// ignore_for_file: lines_longer_than_80_chars, inference_failure_on_function_invocation

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
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
                  address: activeMember!.address != null
                      ? '${activeMember!.address!.streetAddress}, ${activeMember!.address!.city}, ${activeMember!.address!.state}, ${activeMember!.address!.country}'
                      : 'n/a',
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
                        dateUpdated: '25/03/2024',
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
                      HealthCard(
                        isEpr: false,
                        dateUpdated: '25/03/2024',
                        ontap: () {
                          GoRouter.of(context)
                              .push(RoutesConstants.phrPdfViewPage);
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
                        type: SubscriptionType.companion,
                      ),
                      const SizedBox(height: Dimension.d3),
                      const SubscriptionPkg(
                        expanded: true,
                        type: SubscriptionType.wellness,
                      ),
                      const SizedBox(height: Dimension.d3),
                      const SubscriptionPkg(
                        expanded: true,
                        type: SubscriptionType.emergency,
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
    required this.mobileNo,
    this.address,
  });
  final String name;
  final String age;
  final String gender;
  final String? relation;
  final String mobileNo;
  final String? address;

  @override
  Widget build(BuildContext context) {
    final activeMember = GetIt.I<MembersStore>().activeMember;
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
              Avatar.fromSize(imgPath: 'imgPath', size: AvatarSize.size32),
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
                type: SubscriptionType.wellness,
              ),
            ],
          ),
          const SizedBox(height: Dimension.d3),
          Row(
            children: [
              const Icon(
                AppIcons.phone,
                color: AppColors.grayscale700,
                size: 17,
              ),
              const SizedBox(width: Dimension.d3),
              Text(
                mobileNo,
                style: AppTextStyle.bodyLargeMedium
                    .copyWith(color: AppColors.grayscale900),
              ),
            ],
          ),
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
          const SizedBox(height: Dimension.d3),
          CustomButton(
            ontap: () {
              GoRouter.of(context).pushNamed(
                RoutesConstants.addEditFamilyMemberRoute,
                pathParameters: {
                  'edit': 'true',
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
