import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/subscription_pkg.dart';

class AnalogComponent extends StatelessWidget {
  const AnalogComponent({required this.text1, required this.text2, super.key});

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text1,
          style: AppTextStyle.bodyMediumMedium
              .copyWith(color: AppColors.grayscale700),
        ),
        Text(
          ':',
          style: AppTextStyle.bodyMediumMedium
              .copyWith(color: AppColors.grayscale700),
        ),
        const SizedBox(
          width: Dimension.d1,
        ),
        Text(
          text2,
          style: AppTextStyle.bodyMediumMedium
              .copyWith(color: AppColors.grayscale700),
        ),
      ],
    );
  }
}

class CustomComponent extends StatelessWidget {
  const CustomComponent({required this.text, required this.value, super.key});

  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        border: Border.all(
          color: AppColors.line,
        ),
        borderRadius: BorderRadius.circular(Dimension.d1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimension.d3,
          horizontal: Dimension.d2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  text,
                  style: AppTextStyle.bodySmallSemiBold,
                ),
                const SizedBox(
                  width: Dimension.d1,
                ),
                const Icon(
                  AppIcons.ecg_heart,
                  color: AppColors.grayscale600,
                  size: Dimension.d3,
                ),
              ],
            ),
            const SizedBox(
              height: Dimension.d1,
            ),
            Text(
              value,
              style: AppTextStyle.bodyMediumBold,
            ),
          ],
        ),
      ),
    );
  }
}

class VitalInfoComponent extends StatelessWidget {
  const VitalInfoComponent({
    required this.customComponents,
    super.key,
  });
  final List<CustomComponentData> customComponents;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vital Info',
          style: AppTextStyle.bodyMediumSemiBold,
        ),
        const SizedBox(
          height: Dimension.d2,
        ),
        Column(
          children: _buildRows(customComponents),
        ),
        const SizedBox(
          height: Dimension.d2,
        ),
      ],
    );
  }

  List<Widget> _buildRows(List<CustomComponentData> customComponents) {
    final rows = <Widget>[];
    final rowCount = (customComponents.length / 2).ceil();
    for (var i = 0; i < rowCount; i++) {
      final rowData = customComponents.sublist(
        i * 2,
        (i + 1) * 2 > customComponents.length
            ? customComponents.length
            : (i + 1) * 2,
      );
      rows.add(
        Row(
          children: rowData.asMap().entries.map((entry) {
            final index = entry.key;
            final component = entry.value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index == 0 ? Dimension.d2 : 0),
                child: CustomComponent(
                  text: component.text,
                  value: component.value,
                ),
              ),
            );
          }).toList(),
        ),
      );
      if (i < rowCount - 1) {
        rows.add(const SizedBox(height: Dimension.d2));
      }
    }
    return rows;
  }
}

class CustomComponentData {
  const CustomComponentData({
    required this.text,
    required this.value,
  });
  final String text;
  final String value;
}

class ActivePlanComponent extends StatelessWidget {
  const ActivePlanComponent({
    required this.name,
    required this.onTap,
    required this.relation,
    required this.age,
    required this.updatedAt,
    required this.memberPhrId,
    super.key,
  });
  final String name;
  final String relation;
  final String age;
  final DateTime updatedAt;
  final VoidCallback onTap;
  final int memberPhrId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.line,
        ),
        borderRadius: BorderRadius.circular(Dimension.d2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimension.d3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: AppTextStyle.bodyLargeBold,
                ),
                const SubscriptionPkg(
                  expanded: false,
                  type: SubscriptionType.wellness,
                ),
              ],
            ),
            const SizedBox(
              height: Dimension.d1,
            ),
            Row(
              children: [
                AnalogComponent(text1: 'Relation', text2: relation),
                const SizedBox(
                  width: Dimension.d2,
                ),
                AnalogComponent(text1: 'Age', text2: age),
              ],
            ),
            const SizedBox(
              height: Dimension.d3,
            ),
            const VitalInfoComponent(
              customComponents: [
                CustomComponentData(
                  text: 'Blood Pressure',
                  value: '73/140mmHg',
                ),
                CustomComponentData(text: 'Blood Oxygen', value: '98%'),
                CustomComponentData(text: 'Heart Rate', value: '106bpm'),
                CustomComponentData(text: 'Fast Glucose', value: '103 mg/dl'),
              ],
            ),
            const SizedBox(height: Dimension.d2),
            AnalogComponent(
              text1: 'Last Updated',
              text2: updatedAt.toString(),
            ),
            const SizedBox(height: Dimension.d2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomButton(
                    ontap: memberPhrId == -1
                        ? null
                        : () {
                            GoRouter.of(context).pushNamed(
                                RoutesConstants.phrPdfViewPage,
                                pathParameters: {
                                  'memberPhrId': memberPhrId.toString()
                                });
                          },
                    title: 'View PHR',
                    showIcon: false,
                    iconPath: Icons.not_interested,
                    size: ButtonSize.small,
                    type: ButtonType.secondary,
                    expanded: true,
                    iconColor: AppColors.primary,
                  ),
                ),
                const SizedBox(
                  width: Dimension.d4,
                ),
                Expanded(
                  child: CustomButton(
                    ontap: onTap,
                    title: 'View EPR',
                    showIcon: false,
                    iconPath: Icons.not_interested,
                    size: ButtonSize.small,
                    type: ButtonType.secondary,
                    expanded: true,
                    iconColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.line),
            const SizedBox(height: Dimension.d3),
            const Text(
              'Upgrade to Companion genie to benefit more',
              style: AppTextStyle.bodySmallMedium,
            ),
            const SizedBox(
              height: Dimension.d2,
            ),
            GestureDetector(
              onTap: () {
                context.pushNamed(RoutesConstants.geniePage, pathParameters: {
                  'pageTitle': 'Wellness Genie',
                  'defination':
                      'We understand the unpredictability of life, but that shouldn’t hinder your well-being. With our comprehensive emergency support service, we’ll ensure holistic care for you. From sickness to health, here are the promises we intend to deliver',
                  'headline':
                      'A dedicated plan in place, focused on remote health monitoring for you and your loved ones.'
                });
              },
              child: const SubscriptionPkg(
                expanded: true,
                type: SubscriptionType.wellness,
              ),
            )
          ],
        ),
      ),
    );
  }
}
