// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/banner_network_img_component.dart';
import 'package:silver_genie/core/widgets/plan_display_component.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';

class GenieOverviewComponent extends StatelessWidget {
  final String title;
  final String headline;
  final String defination;
  final String subHeading;
  final String imageUrl;
  const GenieOverviewComponent({
    required this.title,
    required this.headline,
    required this.defination,
    required this.subHeading,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimension.d4),
        Text(
          title,
          style:
              AppTextStyle.heading4Bold.copyWith(color: AppColors.grayscale900),
        ),
        const SizedBox(height: Dimension.d2),
        Text(
          headline,
          style: AppTextStyle.bodyMediumMedium
              .copyWith(color: AppColors.grayscale700),
        ),
        const SizedBox(height: Dimension.d5),
        Center(child: BannerImageComponent(imageUrl: imageUrl)),
        const SizedBox(height: Dimension.d3),
        Text(
          subHeading,
          style:
              AppTextStyle.bodyXLBold.copyWith(color: AppColors.grayscale900),
        ),
        const SizedBox(height: Dimension.d1),
        Text(
          defination,
          style: AppTextStyle.bodyMediumMedium
              .copyWith(color: AppColors.grayscale700),
        ),
        const SizedBox(height: Dimension.d5),
      ],
    );
  }
}

class ServiceProvideComponent extends StatefulWidget {
  final String heading;

  final List<Datum> serviceList;
  const ServiceProvideComponent({
    required this.heading,
    required this.serviceList,
    super.key,
  });

  @override
  State<ServiceProvideComponent> createState() =>
      _ServiceProvideComponentState();
}

class _ServiceProvideComponentState extends State<ServiceProvideComponent> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.heading,
          style:
              AppTextStyle.heading5Bold.copyWith(color: AppColors.grayscale900),
        ),
        const SizedBox(height: Dimension.d2),
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: isExpanded ? widget.serviceList.length * 30 : 280,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.serviceList.length,
            itemBuilder: (context, index) {
              return _ServiceCheckBox(
                servicename: widget.serviceList[index].attributes.label,
                isProvide: widget.serviceList[index].attributes.isActive,
              );
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.white,
                  blurRadius: 20,
                  spreadRadius: 20,
                ),
              ],
            ),
            child: Icon(
              isExpanded ? AppIcons.arrow_up_ios : AppIcons.arrow_down_ios,
              size: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class PlanPricingDetailsComponent extends StatefulWidget {
  const PlanPricingDetailsComponent({
    required this.planName,
    required this.pricingDetailsList,
    required this.onSelect,
    super.key,
  });

  final String planName;
  final List<Price> pricingDetailsList;
  final void Function(Price?) onSelect;

  @override
  State<PlanPricingDetailsComponent> createState() =>
      _PlanPricingDetailsComponentState();
}

class _PlanPricingDetailsComponentState
    extends State<PlanPricingDetailsComponent> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.planName.split(' ').first} plans for ${widget.pricingDetailsList.first.benefitApplicableToMembersLimit == 2 ? 'couple' : 'single'}',
          style: AppTextStyle.heading5Bold.copyWith(
            color: AppColors.grayscale900,
          ),
        ),
        const SizedBox(height: Dimension.d4),
        Column(
          children: List.generate(
            widget.pricingDetailsList.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedIndex == index) {
                    selectedIndex = null;
                    widget.onSelect(null);
                  } else {
                    selectedIndex = index;
                    widget.onSelect(widget.pricingDetailsList[index]);
                  }
                });
              },
              child: PlanDisplayComponent(
                isSelected: selectedIndex == index,
                planPriceDetails: widget.pricingDetailsList[index],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ExploreNowComponent extends StatelessWidget {
  const ExploreNowComponent({
    required this.id,
    required this.pageTitle,
    required this.btnLabel,
    required this.planHeading,
    required this.imgPath,
    required this.iconColorCode,
    required this.plansList,
    required this.backgroundColor,
    required this.isUpgradable,
    super.key,
  });

  final String id;
  final String pageTitle;
  final String btnLabel;
  final String planHeading;
  final String imgPath;
  final String iconColorCode;
  final String backgroundColor;
  final List<Price> plansList;
  final bool isUpgradable;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      padding: const EdgeInsets.all(Dimension.d2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grayscale300),
        borderRadius: BorderRadius.circular(Dimension.d2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            planHeading,
            style: AppTextStyle.bodyMediumMedium
                .copyWith(color: AppColors.grayscale700),
          ),
          GestureDetector(
            onTap: () {
              final plansListJson =
                  jsonEncode(plansList.map((plan) => plan.toJson()).toList());
              context.pushNamed(
                RoutesConstants.couplePlanPage,
                pathParameters: {'id': id, 'pageTitle': pageTitle},
                extra: {
                  'plansList': plansListJson,
                  'isUpgradable': isUpgradable.toString(),
                },
              );
            },
            child: Container(
              height: 48,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: Dimension.d2),
              decoration: BoxDecoration(
                color: Color(int.parse(backgroundColor, radix: 16)),
                border: Border.all(
                  color: Color(int.parse(iconColorCode, radix: 16)),
                ),
                borderRadius: BorderRadius.circular(Dimension.d2),
              ),
              child: Row(
                children: [
                  Avatar.fromSize(
                    imgPath: '${Env.serverUrl}$imgPath',
                    size: AvatarSize.size12,
                    fit: BoxFit.contain,
                    isImageSquare: true,
                  ),
                  const SizedBox(
                    width: Dimension.d3,
                  ),
                  Text(
                    btnLabel,
                    style: AppTextStyle.bodyMediumMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    AppIcons.arrow_forward,
                    size: 20,
                    color: Color(int.parse(iconColorCode, radix: 16)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQComponent extends StatelessWidget {
  const FAQComponent({
    required this.heading,
    required this.faqList,
    super.key,
  });

  final String heading;
  final List<Faq> faqList;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style:
              AppTextStyle.bodyXLBold.copyWith(color: AppColors.grayscale900),
        ),
        const SizedBox(height: Dimension.d2),
        Column(
          children: List.generate(
            faqList.length,
            (index) => ExpandingQuestionComponent(
              question: faqList[index].question,
              temp: faqList[index].answer,
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceCheckBox extends StatelessWidget {
  final String servicename;
  final bool isProvide;
  const _ServiceCheckBox({
    required this.servicename,
    required this.isProvide,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icon/success.svg',
          height: 20,
          color: isProvide ? AppColors.primary : AppColors.grayscale600,
        ),
        const SizedBox(width: Dimension.d2),
        Text(
          servicename,
          style: AppTextStyle.bodyMediumMedium.copyWith(
            height: 2,
            color: isProvide ? AppColors.grayscale900 : AppColors.grayscale700,
          ),
        ),
      ],
    );
  }
}

class ExpandingQuestionComponent extends StatefulWidget {
  const ExpandingQuestionComponent({
    required this.question,
    required this.temp,
    super.key,
  });
  final String question;
  final String temp;

  @override
  State<ExpandingQuestionComponent> createState() =>
      _ExpandingQuestionComponentState();
}

class _ExpandingQuestionComponentState
    extends State<ExpandingQuestionComponent> {
  bool isExpanding = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isExpanding = !isExpanding;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 310,
                  child: Text(
                    isExpanding
                        ? '${widget.question}\n${widget.temp}'
                        : widget.question,
                    style: AppTextStyle.bodyLargeMedium
                        .copyWith(color: AppColors.grayscale900),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Icon(
                      isExpanding
                          ? AppIcons.arrow_up_ios
                          : AppIcons.arrow_down_ios,
                      size: 8),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: AppColors.grayscale300,
        ),
      ],
    );
  }
}
