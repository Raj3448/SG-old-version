import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/inactive_plan.dart';
import 'package:silver_genie/core/widgets/subscription_pkg.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';

class ExpandedAnalogComponent extends StatelessWidget {
  const ExpandedAnalogComponent(
      {required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyle.bodyMediumMedium,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            ':  $value',
            style: AppTextStyle.bodyMediumMedium
                .copyWith(color: AppColors.grayscale700),
          ),
        ),
      ],
    );
  }
}

class AnalogComponent extends StatelessWidget {
  const AnalogComponent({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyle.bodyMediumMedium
              .copyWith(color: AppColors.grayscale900),
        ),
        Text(
          ':',
          style: AppTextStyle.bodyMediumMedium
              .copyWith(color: AppColors.grayscale900),
        ),
        const SizedBox(
          width: Dimension.d1,
        ),
        Text(
          value,
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
  ActivePlanComponent({
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
  final String updatedAt;
  final VoidCallback onTap;
  final int? memberPhrId;
  final store = GetIt.I<ProductListingStore>();
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
                SubscriptionPkg(
                  expanded: false,
                  type: SubscriptionsType.wellness,
                ),
              ],
            ),
            const SizedBox(
              height: Dimension.d1,
            ),
            Row(
              children: [
                AnalogComponent(label: 'Relation', value: relation),
                const SizedBox(
                  width: Dimension.d2,
                ),
                AnalogComponent(label: 'Age', value: age),
              ],
            ),
            const SizedBox(
              height: Dimension.d3,
            ),
            const Text(
              'Vital Info',
              style: AppTextStyle.bodyMediumSemiBold,
            ),
            const SizedBox(
              height: Dimension.d2,
            ),
            GridView.builder(
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.4,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final phrModel = widget.activeMember.phrModel;
                final diagnosedServices = phrModel?.diagnosedServices;

                if (diagnosedServices == null || diagnosedServices.isEmpty) {
                  return const _VitalInfoBox(
                    label: '---',
                    value: '---',
                  );
                }

                final diagnosedService = diagnosedServices[index];

                return GestureDetector(
                  onLongPress: () => _showTooltip(index),
                  child: Tooltip(
                    key: _tooltipKeys[index],
                    enableFeedback: true,
                    message: formatDateTime(diagnosedService.diagnosedDate),
                    child: _VitalInfoBox(
                      label: diagnosedService.description.isNotEmpty
                          ? diagnosedService.description
                          : '---',
                      value: diagnosedService.value.isNotEmpty
                          ? diagnosedService.value
                          : '---',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: Dimension.d2),
            AnalogComponent(
              label: 'Last Updated',
              value: updatedAt.toString(),
            ),
            const SizedBox(height: Dimension.d2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomButton(
                    ontap: memberPhrId == null
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
                    type: memberPhrId == null
                        ? ButtonType.disable
                        : ButtonType.secondary,
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
            _UpgradeProdLisComponent(
              productBasicDetailsList: store.getUpgradeProdListById('2'),
            )
          ],
        ),
      ),
    );
  }
}

class _UpgradeProdLisComponent extends StatelessWidget {
  _UpgradeProdLisComponent({required this.productBasicDetailsList, super.key});

  final List<ProductBasicDetailsModel> productBasicDetailsList;
  final store = GetIt.I<ProductListingStore>();
  @override
  Widget build(BuildContext context) {
    return productBasicDetailsList.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(color: AppColors.line),
              const SizedBox(height: Dimension.d3),
              const Text(
                'Upgrade to Companion genie to benefit more',
                style: AppTextStyle.bodySmallMedium,
              ),
              const SizedBox(
                height: Dimension.d2,
              ),
              ProductListingCareComponent(
                isUpgradable: true,
                productBasicDetailsList:
                    store.getProdListRankOrder(productBasicDetailsList),
              ),
            ],
          );
  }
}
