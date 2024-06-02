// ignore_for_file: inference_failure_on_function_invocation

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/member_creation.dart';

class NoMember extends StatelessWidget {
  const NoMember({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Family Member',
                      style: AppTextStyle.bodyMediumBold
                          .copyWith(color: AppColors.grayscale900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Unlock booking and services.',
                      style: AppTextStyle.bodySmallMedium
                          .copyWith(color: AppColors.grayscale700),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
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
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.line),
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Icon(
                        AppIcons.add,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.secondary,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get personalized care for your loved one',
                      style: AppTextStyle.bodyMediumBold
                          .copyWith(color: AppColors.grayscale900),
                    ),
                    const SizedBox(height: 8),
                    const _Feature(title: 'Personalized care packages'),
                    const SizedBox(height: 8),
                    const _Feature(title: 'On-demand services booking'),
                    const SizedBox(height: 8),
                    const _Feature(title: 'Insightful supports from our team'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            CustomButton(
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return MemberCreation(
                      selfOnTap: () {},
                      memberOnTap: () {
                        context.pushNamed(
                          RoutesConstants.addEditFamilyMemberRoute,
                          pathParameters: {'edit': 'false'},
                        );
                      },
                    );
                  },
                );
              },
              title: 'Add Member',
              showIcon: false,
              iconPath: AppIcons.add,
              size: ButtonSize.large,
              type: ButtonType.primary,
              expanded: true,
              iconColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          AppIcons.check,
          color: AppColors.primary,
          size: 12,
        ),
        const SizedBox(width: 20),
        Text(
          title,
          style: AppTextStyle.bodyMediumMedium
              .copyWith(color: AppColors.grayscale800),
        ),
      ],
    );
  }
}
