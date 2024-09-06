// ignore_for_file: avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:easy_localization/easy_localization.dart';
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
import 'package:silver_genie/core/utils/custom_extension.dart';
import 'package:silver_genie/core/utils/custom_tuple.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/inactive_plan.dart';
import 'package:silver_genie/core/widgets/subscription_plan_tag.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';

class ExpandedAnalogComponent extends StatelessWidget {
  const ExpandedAnalogComponent({
    required this.label,
    required this.value,
    this.maxLines = 1,
    super.key,
  });

  final String label;
  final String value;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyle.bodyMediumMedium,
          ),
        ),
        Text(
          ':',
          style: AppTextStyle.bodyMediumMedium
              .copyWith(color: AppColors.grayscale700),
        ),
        const SizedBox(
          width: Dimension.d2,
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            //overflow: TextOverflow.ellipsis,
            //maxLines: maxLines,
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

  final List<HealthService> healthServices = [
    const HealthService(serviceName: 'blood pressure', unitStr: 'mmHg'),
    const HealthService(serviceName: 'blood oxygen', unitStr: '%'),
    const HealthService(serviceName: 'heart rate', unitStr: 'bpm'),
    const HealthService(serviceName: 'fast glucose', unitStr: 'mg/dL'),
  ];

  @override
  Widget build(BuildContext context) {
    const emptyStrValue = '---';
    final phrModel = widget.activeMember.phrModel;
    final diagnosedServices = phrModel?.diagnosedServices ?? [];
    final member = widget.activeMember.subscriptions?[0];
    final healthServiceNames = healthServices
        .map((service) => service.serviceName.toLowerCase().trim())
        .toSet();
    final latestServices = <String, DiagnosedService>{};
    for (final service in diagnosedServices) {
      final serviceName = service.serviceName?.name.toLowerCase().trim();
      if (serviceName != null && healthServiceNames.contains(serviceName)) {
        final currentLatestService = latestServices[serviceName];
        if (currentLatestService == null ||
            (service.diagnosedDate != null &&
                service.diagnosedDate!.isAfter(
                  currentLatestService.diagnosedDate ?? DateTime(0),
                ))) {
          latestServices[serviceName] = service;
        }
      }
    }

    final filteredDiagnosedServices = healthServices.map((service) {
      final diagnosedService = latestServices[service.serviceName] ??
          DiagnosedService(
            id: 0,
            diagnosedDate: DateTime.now(),
            description: '',
            value: emptyStrValue,
            publish: false,
            serviceName: ServiceName(
              id: 0,
              name: service.serviceName.capitalizeFirstWord(),
              description: null,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
      return Tuple2(diagnosedService, service.unitStr);
    }).toList();

    final hasPHR = widget.activeMember.subscriptions?[0].benefits?.any(
          (benefit) => benefit.code == 'PHR' && benefit.isActive,
        ) ??
        false;
    final hasEPR = widget.activeMember.subscriptions?[0].benefits?.any(
          (benefit) => benefit.code == 'EPR' && benefit.isActive,
        ) ??
        false;

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
                Flexible(
                  child: Text(
                    '${widget.activeMember.firstName} ${widget.activeMember.lastName}',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.bodyLargeBold,
                  ),
                ),
                if (widget.activeMember.subscriptions!.isEmpty)
                  const SubscriptionPlanTag(
                    label: 'In-active',
                  )
                else
                  SubscriptionPlanTag(
                    label: widget.activeMember.subscriptions![0].product.name, backgroundColorCode: getMetadataValue(widget.activeMember.subscriptions?[0].product.metadata??[],'background_color_code'), iconColorCode: getMetadataValue(widget.activeMember.subscriptions?[0].product.metadata??[], 'icon_color_code')),
              ],
            ),
            const SizedBox(height: Dimension.d1),
            Row(
              children: [
                AnalogComponent(
                  label: 'Relation',
                  value: widget.activeMember.relation,
                ),
                const SizedBox(width: Dimension.d2),
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
                    message: diagnosedService.item1.diagnosedDate == null ? 'Diagnosed date not found' : formatDateTime(
                      diagnosedService.item1.diagnosedDate!,
                    ),
                    child: _VitalInfoBox(
                      label: diagnosedService.item1.serviceName?.name != null
                          ? diagnosedService.item1.serviceName?.name
                              .capitalizeFirstWord()
                          : '',
                      value: diagnosedService.item1.value.isNotEmpty &&
                              diagnosedService.item1.value != emptyStrValue
                          ? '${diagnosedService.item1.value}${diagnosedService.item2 == '%' ? diagnosedService.item2 : ' ${diagnosedService.item2}'}'
                          : emptyStrValue,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: Dimension.d2),
            AnalogComponent(
              label: 'Last Updated'.tr(),
              value: formatDateTime(widget.activeMember.updatedAt.toLocal()),
            ),
            const SizedBox(height: Dimension.d2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomButton(
                    ontap:
                        hasPHR == false || widget.activeMember.phrModel == null
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
                    type:
                        hasPHR == false || widget.activeMember.phrModel == null
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
            ),
            if (member != null) _buildRenewalAndExpirationInfo(member),
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

Widget _buildRenewalAndExpirationInfo(
  SubscriptionDetails member,
) {
  final expiresIn = calculateDaysRemaining(member.expiresOn);
  if (expiresIn < 0 || expiresIn > 3) {
    return const SizedBox();
  }

  if (member.razorpay_subscription?.status == 'pending') {
    return _buildStatusInfo(
      message: 'Auto renewal failed, Reach Support team.',
    );
  }

  if (member.razorpay_subscription?.status == 'active') {
    final renewsIn = calculateDaysRemaining(
      member.razorpay_subscription?.chargeAt ?? member.expiresOn,
    );
    if (renewsIn < 0 || renewsIn > 3) {
      return const SizedBox();
    }
    return _buildStatusInfo(
      message: 'renewsIn'.plural(renewsIn),
    );
  }
  return _buildStatusInfo(
    message: 'expiresIn'.plural(expiresIn),
  );
}

Widget _buildStatusInfo({required String message}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Divider(color: AppColors.line),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimension.d2),
        child: Center(
          child: Text(
            message,
            style: AppTextStyle.bodyMediumMedium.copyWith(
              color: AppColors.error,
            ),
          ),
        ),
      ),
    ],
  );
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
    final prodList = store.getProdListRankOrder(productBasicDetailsList);
    return productBasicDetailsList.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(color: AppColors.line),
              const SizedBox(height: Dimension.d3),
              Text(
                'Upgrade to ${prodList.first.attributes.name} to benefit more',
                style: AppTextStyle.bodySmallMedium,
              ),
              const SizedBox(height: Dimension.d2),
              ProductListingCareComponent(
                isUpgradeable: true,
                productBasicDetailsList: prodList,
              ),
            ],
          );
  }
}

int calculateDaysRemaining(DateTime date) {
  final now = DateTime.now();

  final differenceInDays = date.difference(now).inDays;

  return differenceInDays;
}
