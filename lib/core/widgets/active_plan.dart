// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/utils/calculate_age.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/inactive_plan.dart';
import 'package:silver_genie/core/widgets/subscription_pkg.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';

class ExpandedAnalogComponent extends StatelessWidget {
  const ExpandedAnalogComponent({
    required this.label,
    required this.value,
    super.key,
  });

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
          style: AppTextStyle.bodySmallMedium
              .copyWith(color: AppColors.grayscale700),
        ),
        Text(
          ':',
          style: AppTextStyle.bodySmallMedium
              .copyWith(color: AppColors.grayscale700),
        ),
        const SizedBox(width: Dimension.d1),
        Text(
          value,
          style: AppTextStyle.bodySmallMedium
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

class ActivePlanComponent extends StatefulWidget {
  const ActivePlanComponent({
    required this.activeMember,
    super.key,
  });
  final Member activeMember;

  @override
  State<ActivePlanComponent> createState() => _ActivePlanComponentState();
}

class _ActivePlanComponentState extends State<ActivePlanComponent> {
  final store = GetIt.I<ProductListingStore>();
  final memberStore = GetIt.I<MembersStore>();
  late List<GlobalKey> _tooltipKeys;

  @override
  void initState() {
    super.initState();
    _tooltipKeys = List.generate(4, (index) => GlobalKey());
  }

  void _showTooltip(int index) {
    final dynamic tooltip = _tooltipKeys[index].currentState;
    tooltip.ensureTooltipVisible();
  }

  final List<String> desiredServices = [
    'Blood Pressure',
    'Blood Oxygen',
    'Heart Rate',
    'Fast Glucose',
  ];

  @override
  Widget build(BuildContext context) {
    final phrModel = widget.activeMember.phrModel;
    final diagnosedServices = phrModel?.diagnosedServices ?? [];

    final latestServices = <String, DiagnosedService>{};
    for (final service in diagnosedServices) {
      if (desiredServices.contains(service.description)) {
        if (!latestServices.containsKey(service.description) ||
            service.diagnosedDate
                .isAfter(latestServices[service.description]!.diagnosedDate)) {
          latestServices[service.description] = service;
        }
      }
    }

    final filteredDiagnosedServices = desiredServices.map((description) {
      return latestServices[description] ??
          DiagnosedService(
            id: 0,
            description: description,
            value: '---',
            diagnosedDate: DateTime.now(),
            publish: false,
          );
    }).toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
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
                  '${widget.activeMember.firstName} ${widget.activeMember.lastName}',
                  style: AppTextStyle.bodyLargeBold,
                ),
                if (widget.activeMember.subscriptions!.isEmpty)
                  SubscriptionPkg(
                    expanded: false,
                    type: SubscriptionsType.inActive,
                  )
                else
                  SubscriptionPkg(
                    expanded: false,
                    type: widget.activeMember.subscriptions![0].product.name ==
                            'Companion Genie'
                        ? SubscriptionsType.companion
                        : widget.activeMember.subscriptions![0].product.name ==
                                'Wellness Genie'
                            ? SubscriptionsType.wellness
                            : SubscriptionsType.emergency,
                  ),
              ],
            ),
            const SizedBox(height: Dimension.d1),
            Row(
              children: [
                AnalogComponent(
                  label: 'Relation',
                  value: widget.activeMember.relation,
                ),
                const SizedBox(
                  width: Dimension.d2,
                ),
                AnalogComponent(
                  label: 'Age',
                  value: '${calculateAge(widget.activeMember.dateOfBirth)}',
                ),
              ],
            ),
            const SizedBox(height: Dimension.d3),
            const Text(
              'Vital Info',
              style: AppTextStyle.bodyMediumSemiBold,
            ),
            const SizedBox(height: Dimension.d2),
            GridView.builder(
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                mainAxisExtent: 70,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final diagnosedService = filteredDiagnosedServices[index];

                return GestureDetector(
                  onLongPress: () => _showTooltip(index),
                  child: Tooltip(
                    key: _tooltipKeys[index],
                    enableFeedback: true,
                    message: formatDateTime(diagnosedService.diagnosedDate),
                    child: _VitalInfoBox(
                      label: diagnosedService.description,
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
              value: formatDateTime(widget.activeMember.updatedAt.toLocal()),
            ),
            const SizedBox(height: Dimension.d2),
            Observer(builder: (_) {
              final hasPHR = widget.activeMember.subscriptions?[0].benefits
                      ?.any((benefits) => benefits.code == 'PHR') ??
                  false;
              final hasEPR = widget.activeMember.subscriptions?[0].benefits
                      ?.any((benefits) => benefits.code == 'EPR') ??
                  false;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomButton(
                      ontap: hasPHR == false
                          ? null
                          : () {
                              GoRouter.of(context).pushNamed(
                                RoutesConstants.phrPdfViewPage,
                                pathParameters: {
                                  'memberPhrId':
                                      '${widget.activeMember.phrModel?.id}',
                                },
                              );
                            },
                      title: 'View PHR',
                      showIcon: false,
                      iconPath: Icons.not_interested,
                      size: ButtonSize.small,
                      type: hasPHR == false
                          ? ButtonType.disable
                          : ButtonType.secondary,
                      expanded: true,
                      iconColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: Dimension.d4),
                  Expanded(
                    child: CustomButton(
                      ontap: hasEPR == false
                          ? null
                          : () {
                              GoRouter.of(context).pushNamed(
                                RoutesConstants.eprRoute,
                                pathParameters: {
                                  'memberId': '${widget.activeMember.id}',
                                },
                              );
                            },
                      title: 'View EPR',
                      showIcon: false,
                      iconPath: Icons.not_interested,
                      size: ButtonSize.small,
                      type: hasEPR == false
                          ? ButtonType.disable
                          : ButtonType.secondary,
                      expanded: true,
                      iconColor: AppColors.primary,
                    ),
                  ),
                ],
              );
            }),
            if (memberStore.activeMember != null &&
                memberStore.activeMember!.subscriptions != null)
              Observer(
                builder: (context) {
                  return _UpgradeProdLisComponent(
                    productBasicDetailsList: store.getUpgradeProdListById(
                      '${memberStore.activeMember!.subscriptions![0].product.id}',
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _VitalInfoBox extends StatelessWidget {
  const _VitalInfoBox({this.label, this.value});

  final String? label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: 148,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label!,
                style: AppTextStyle.bodySmallMedium.copyWith(
                  color: AppColors.grayscale600,
                ),
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
          const SizedBox(height: Dimension.d1),
          Text(
            value!,
            style: AppTextStyle.bodyMediumBold,
          ),
        ],
      ),
    );
  }
}

class _UpgradeProdLisComponent extends StatelessWidget {
  _UpgradeProdLisComponent({required this.productBasicDetailsList});

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
              const SizedBox(height: Dimension.d2),
              ProductListingCareComponent(
                isUpgradeable: true,
                productBasicDetailsList:
                    store.getProdListRankOrder(productBasicDetailsList),
              ),
            ],
          );
  }
}
