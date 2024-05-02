// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/fonts.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/plan_display_component.dart';
import 'package:silver_genie/feature/emergency_services/store/emergency_service_store.dart';

class GenieOverviewComponent extends StatelessWidget {
  final String title;
  final String headline;
  final String defination;
  const GenieOverviewComponent(
      {required this.title,
      required this.headline,
      required this.defination,
      Key? key})
      : super(key: key);

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
        Center(
          child: SvgPicture.asset(
            'assets/emergency/rafiki.svg',
            height: 206,
            width: 277,
          ),
        ),
        const SizedBox(
          height: Dimension.d3,
        ),
        Text(
          'What is ${title.toLowerCase()}?',
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
  final List<Map<String, dynamic>> serviceDetailsList;
  const ServiceProvideComponent({required this.serviceDetailsList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services we provide',
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
              itemCount: serviceDetailsList.length,
              itemBuilder: (context, index) {
                return _ServiceCheckBox(
                  servicename:
                      serviceDetailsList[index]['servicename'] as String,
                  isProvide: serviceDetailsList[index]['isProvide'] as bool,
                );
              }),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: AppColors.grayscale100, blurRadius: 7, spreadRadius: 12)
          ]),
          alignment: Alignment(0, 0),
          child: Icon(
            AppIcons.arrow_down_ios,
            size: 6,
          ),
        )
      ],
    );
  }
}

class PlanPricingDetailsComponent extends StatelessWidget {
  PlanPricingDetailsComponent({required this.planName, super.key});

  final String planName;
  final store = GetIt.I<EmergencyServiceStore>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${planName.split(' ').first} plans for single',
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
        SizedBox(
          height: 380,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: store.emergencyServiceModel.plans.length,
            itemBuilder: (context, index) {
              return PlanDisplayComponent(
                plan: store.emergencyServiceModel.plans[index],
              );
            },
          ),
        )
      ],
    );
  }
}

class ExploreNowComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      padding: const EdgeInsets.all(Dimension.d2),
      margin: const EdgeInsets.symmetric(vertical: Dimension.d6),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColors.grayscale300),
          borderRadius: BorderRadius.circular(Dimension.d2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Unlock even more benefits and discounts with our Couple Plan.',
            style: AppTextStyle.bodyMediumMedium
                .copyWith(color: AppColors.grayscale700),
          ),
          GestureDetector(
            onTap: () {
              context.pushNamed(RoutesConstants.couplePlanPage,pathParameters: {
                'pageTitle' : 'Wellness Genie'
              });
            },
            child: Container(
                height: 48,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: Dimension.d2),
                decoration: BoxDecoration(
                    color: AppColors.secondary,
                    border: Border.all(width: 1, color: AppColors.primary),
                    borderRadius: BorderRadius.circular(Dimension.d2)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icon/avg_time.png',
                      height: 21,
                    ),
                    const SizedBox(
                      width: Dimension.d3,
                    ),
                    Text(
                      'Explore Now',
                      style: AppTextStyle.bodyMediumMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      AppIcons.arrow_forward,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}

class HowItWorkComponent extends StatelessWidget {
  const HowItWorkComponent({required this.questionsAndContentList, super.key});

  final List<Map<String, dynamic>> questionsAndContentList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How It works?',
          style: AppTextStyle.bodyMediumMedium.copyWith(
            fontSize: 20,
            fontFamily: FontFamily.inter,
            fontWeight: FontWeight.w600,
            height: 2.514,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
              itemCount: questionsAndContentList.length,
              itemBuilder: (context, index) {
                return ExpandingQuestionComponent(
                    question:
                        questionsAndContentList[index]['question'] as String,
                    temp: questionsAndContentList[index]['answer'] as String);
              }),
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
              color:
                  isProvide ? AppColors.grayscale900 : AppColors.grayscale700),
        )
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
