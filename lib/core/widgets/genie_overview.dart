// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/fonts.dart';
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.bodyMediumMedium.copyWith(
            color: AppColors.grayscale900,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.46,
          ),
        ),
        const SizedBox(
          height: Dimension.d1,
        ),
        Text(
          headline,
          style: AppTextStyle.bodyMediumMedium.copyWith(
            color: AppColors.grayscale700,
            fontSize: 14,
            height: 1.46,
          ),
        ),
        const SizedBox(
          height: Dimension.d5,
        ),
        Center(child: BannerImageComponent(imageUrl: imageUrl)),
        const SizedBox(
          height: Dimension.d3,
        ),
        Text(
          'What is ${subHeading.toLowerCase()}?',
          style: AppTextStyle.bodyMediumMedium.copyWith(
            color: AppColors.grayscale900,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.46,
          ),
        ),
        const SizedBox(
          height: Dimension.d1,
        ),
        Text(
          defination,
          style: AppTextStyle.bodyMediumMedium.copyWith(
            color: AppColors.grayscale700,
            fontSize: 14,
            height: 1.46,
          ),
        ),
        const SizedBox(
          height: Dimension.d4,
        ),
      ],
    );
  }
}

class ServiceProvideComponent extends StatelessWidget {
  final String heading;

  final List<Datum> serviceList;
  const ServiceProvideComponent(
      {required this.heading, required this.serviceList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: AppTextStyle.bodyMediumMedium.copyWith(
            color: AppColors.grayscale900,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.46,
          ),
        ),
        const SizedBox(
          height: Dimension.d2,
        ),
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          height: 350,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: serviceList.length,
            itemBuilder: (context, index) {
              return _ServiceCheckBox(
                servicename: serviceList[index].attributes.label,
                isProvide: serviceList[index].attributes.isActive,
              );
            },
          ),
        ),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.grayscale100,
                blurRadius: 7,
                spreadRadius: 12,
              ),
            ],
          ),
          alignment: Alignment(0, 0),
          child: const Icon(
            AppIcons.arrow_down_ios,
            size: 6,
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
    Key? key,
  }) : super(key: key);

  final String planName;
  final List<Price> pricingDetailsList;
  final void Function(Price) onSelect;

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
          style: AppTextStyle.bodyMediumMedium.copyWith(
            fontFamily: FontFamily.plusJakarta,
            color: AppColors.grayscale900,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.46,
          ),
        ),
        const SizedBox(
          height: Dimension.d4,
        ),
        Column(
          children: List.generate(
            widget.pricingDetailsList.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedIndex == index) {
                    selectedIndex = null;
                  } else {
                    selectedIndex = index;
                    widget.onSelect(widget.pricingDetailsList[index]);
                    print('Selected');
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
    required this.pageTitle,
    required this.btnLabel,
    required this.planHeading,
    required this.imgPath,
    required this.iconColorCode,
    required this.plansList,
    required this.backgroundColor,
    super.key,
  });

  final String pageTitle;
  final String btnLabel;
  final String planHeading;
  final String imgPath;
  final String iconColorCode;
  final String backgroundColor;
  final List<Price> plansList;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      padding: const EdgeInsets.all(Dimension.d2),
      margin: const EdgeInsets.symmetric(vertical: Dimension.d6),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.grayscale300),
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
                pathParameters: {'pageTitle': pageTitle},
                extra: {'plansList': plansListJson},
              );
            },
            child: Container(
              height: 48,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: Dimension.d2),
              decoration: BoxDecoration(
                color: Color(int.parse(backgroundColor, radix: 16)),
                border: Border.all(
                    width: 1,
                    color: Color(int.parse(iconColorCode, radix: 16))),
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
    Key? key,
  }) : super(key: key);
  final String heading;
  final List<Faq> faqList;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: AppTextStyle.bodyMediumMedium.copyWith(
            fontSize: 20,
            fontFamily: FontFamily.inter,
            fontWeight: FontWeight.w600,
            height: 2.514,
          ),
        ),
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
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icon/success.svg',
          height: 20,
          color: isProvide ? AppColors.primary : AppColors.grayscale600,
        ),
        const SizedBox(
          width: Dimension.d2,
        ),
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
                    style: AppTextStyle.bodyMediumMedium.copyWith(
                      fontSize: 16,
                      fontFamily: FontFamily.inter,
                      fontWeight: FontWeight.w400,
                      //overflow: isExpanding ? null : TextOverflow.ellipsis,
                      height: 2,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'assets/icon/Frame.png',
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
