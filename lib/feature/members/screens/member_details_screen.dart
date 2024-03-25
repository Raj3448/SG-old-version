// ignore_for_file: lines_longer_than_80_chars, inference_failure_on_function_invocation

import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/epr_card.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/members/screens/edit_member_details_screen.dart';
import 'package:silver_genie/feature/members/screens/epr_phr_view_screen.dart';
import 'package:silver_genie/feature/members/widgets/subscribe_card.dart';

class MemberDetailsScreen extends StatelessWidget {
  const MemberDetailsScreen({
    required this.name,
    required this.age,
    required this.gender,
    required this.relation,
    required this.mobileNo,
    required this.address,
    required this.hasCareSub,
    super.key,
  });

  final String name;
  final String age;
  final String gender;
  final String relation;
  final String mobileNo;
  final String address;
  final bool hasCareSub;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PageAppbar(title: 'Member Details'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const _Button(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic details',
                style: AppTextStyle.bodyXLMedium
                    .copyWith(color: AppColors.grayscale900),
              ),
              const SizedBox(height: 16),
              _BasicDetailsBox(
                name: name,
                age: age,
                gender: gender,
                relation: relation,
                mobileNo: mobileNo,
                address: address,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EPRPHRViewScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    HealthCard(
                      isEpr: false,
                      dateUpdated: '25/03/2024',
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EPRPHRViewScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                )
              else
                const Column(
                  children: [
                    SubscribeCard(),
                    SizedBox(height: 16),
                    PlanDetailsCard(),
                    SizedBox(height: 55),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
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
            title: 'Update health record',
            showIcon: false,
            iconPath: AppIcons.check,
            size: ButtonSize.normal,
            type: ButtonType.primary,
            expanded: true,
          ),
        ],
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
    required this.address,
  });
  final String name;
  final String age;
  final String gender;
  final String relation;
  final String mobileNo;
  final String address;

  @override
  Widget build(BuildContext context) {
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
              Text(name, style: AppTextStyle.bodyLargeMedium),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditMemberScreen(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.primary),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                  child: Text(
                    'Edit',
                    style: AppTextStyle.bodyMediumMedium
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // const Relationship(relation: 'Father'),
          _Field(
            age: age,
            gender: gender,
            relation: relation,
            mobileNo: mobileNo,
            address: address,
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.age,
    required this.gender,
    required this.relation,
    required this.mobileNo,
    required this.address,
  });

  final String age;
  final String gender;
  final String relation;
  final String mobileNo;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Age',
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale600),
            ),
            const SizedBox(height: 7),
            Text(
              'Gender',
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale600),
            ),
            const SizedBox(height: 7),
            Text(
              'Relationship',
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale600),
            ),
            const SizedBox(height: 7),
            Text(
              'Mobile number',
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale600),
            ),
            const SizedBox(height: 7),
            Text(
              'Address',
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale600),
            ),
            const SizedBox(height: 7),
          ],
        ),
        const SizedBox(width: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ': $age',
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale600),
            ),
            const SizedBox(height: 7),
            Text(
              ': $gender',
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale600),
            ),
            const SizedBox(height: 7),
            Text(
              ': $relation',
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale600),
            ),
            const SizedBox(height: 7),
            Text(
              ': $mobileNo',
              style: AppTextStyle.bodyMediumMedium
                  .copyWith(color: AppColors.grayscale600),
            ),
            const SizedBox(height: 7),
            SizedBox(
              width: 230,
              child: Text(
                ': $address',
                style: AppTextStyle.bodyMediumMedium
                    .copyWith(color: AppColors.grayscale600),
              ),
            ),
            const SizedBox(height: 7),
          ],
        ),
      ],
    );
  }
}
