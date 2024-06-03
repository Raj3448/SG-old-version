// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/fonts.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/genie_overview.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/plan_display_component.dart';
import 'package:silver_genie/core/widgets/title_descript_component.dart';
import 'package:silver_genie/feature/emergency_services/model/emergency_service_model.dart';
import 'package:silver_genie/feature/emergency_services/store/emergency_service_store.dart';

class EmergencyServices extends StatefulWidget {
  const EmergencyServices({super.key});

  @override
  State<EmergencyServices> createState() => _EmergencyServicesState();
}

class _EmergencyServicesState extends State<EmergencyServices> {
  @override
  Widget build(BuildContext context) {
    const temp =
        'jhsjhs ssjhsjhsjsd sdssjss s ssjshs sjhshjw wwkwjwkw wkjwkwj tgtgghtrr tttryty ttrtt ttt tggfgrgrgregergregregregregregreregree  gggrg rgrgre r rrsss segesge';
    final store = GetIt.I<EmergencyServiceStore>();
    return Scaffold(
      appBar: const PageAppbar(title: 'Emergency services'),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Emergency Services',
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
                "Stay prepared with our emergency services. We're here for you during health scares.",
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
                'What is emergency services?',
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
                store.emergencyServiceModel.defination,
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColors.grayscale700,
                  fontSize: 14,
                  height: 1.46,
                ),
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
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
                height: Dimension.d5,
              ),
              TitleDescriptComponent(
                title: 'Preparedness Support',
                description: store.emergencyServiceModel.support.preparedness,
              ),
              const SizedBox(
                height: Dimension.d2,
              ),
              TitleDescriptComponent(
                title: 'Hospital Support',
                description: store.emergencyServiceModel.support.hospital,
              ),
              const SizedBox(
                height: Dimension.d2,
              ),
              TitleDescriptComponent(
                title: 'Post-discharge Support',
                description: store.emergencyServiceModel.support.postDischarge,
              ),
              const SizedBox(
                height: Dimension.d2,
              ),
              TitleDescriptComponent(
                title: 'Health-monitoring Support',
                description: store.emergencyServiceModel.support.healthMonitor,
              ),
              const SizedBox(
                height: Dimension.d2,
              ),
              TitleDescriptComponent(
                title: 'Genie Care Support',
                description: store.emergencyServiceModel.support.genieCare,
              ),
              const SizedBox(
                height: Dimension.d5,
              ),
              Text(
                'Emergency Service Plans',
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  fontFamily: FontFamily.plusJakarta,
                  color: AppColors.grayscale900,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.46,
                ),
              ),
              const SizedBox(
                height: Dimension.d5,
              ),
              Text(
                store.emergencyServiceModel.plansDescription,
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColors.grayscale700,
                  fontSize: 14,
                  height: 1.46,
                ),
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              Column(
                children: List.generate(
                    store.emergencyServiceModel.plans.length,
                    (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              final updatedPlans = List<Plan>.from(store.emergencyServiceModel.plans);
                              for (int i = 0; i < updatedPlans.length; i++) {
                                updatedPlans[i] = updatedPlans[i].copyWith(isSelected: i == index);
                              }
                              store.emergencyServiceModel = store.emergencyServiceModel.copyWith(plans: updatedPlans);
                            });
                          },
                          child: PlanDisplayComponent(
                            planPriceDetails: null,
                            
                          ),
                        )),
              ),
              Text(
                'How It works?',
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColors.grayscale700,
                  fontSize: 20,
                  fontFamily: FontFamily.inter,
                  fontWeight: FontWeight.w600,
                  height: 2.514,
                ),
              ),
              const ExpandingQuestionComponent(
                temp: temp,
                question: 'We will require some important',
              ),
              const ExpandingQuestionComponent(
                temp: temp,
                question: 'Our genie can get on a call with you, or',
              ),
              const ExpandingQuestionComponent(
                temp: temp,
                question: 'Once we have set up the emergency ',
              ),
              const ExpandingQuestionComponent(
                temp: temp,
                question: 'Please note that our emergency',
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              CustomButton(
                ontap: () {},
                title: 'Contact Genie',
                showIcon: false,
                iconPath: AppIcons.add,
                size: ButtonSize.normal,
                type: ButtonType.primary,
                expanded: true,
                iconColor: AppColors.white,
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
