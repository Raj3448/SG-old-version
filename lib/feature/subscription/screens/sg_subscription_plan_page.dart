// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/fonts.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/back_to_home_bottom_sheet-comp.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/genie_overview.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/plan_display_component.dart';
import 'package:silver_genie/core/widgets/title_descript_component.dart';
import 'package:silver_genie/feature/emergency_services/model/emergency_service_model.dart';
import 'package:silver_genie/feature/emergency_services/store/emergency_service_store.dart';

class SGSubcscriptionPage extends StatefulWidget {
  const SGSubcscriptionPage({super.key});

  @override
  State<SGSubcscriptionPage> createState() => _SGSubcscriptionPageState();
}

class _SGSubcscriptionPageState extends State<SGSubcscriptionPage> {
  @override
  Widget build(BuildContext context) {
    const temp =
        'jhsjhs ssjhsjhsjsd sdssjss s ssjshs sjhshjw wwkwjwkw wkjwkwj tgtgghtrr tttryty ttrtt ttt tggfgrgrgregergregregregregregreregree  gggrg rgrgre r rrsss segesge';
    final store = GetIt.I<EmergencyServiceStore>();
    return Scaffold(
      appBar: const PageAppbar(title: 'SG Subscription plans'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GenieOverviewComponent(
                  imageUrl: '',
                  subHeading: 'uyweuwe',
                  title: 'SG+ Subscription plans',
                  headline:
                      'A dedicated plan in place, focused on remote health monitoring for you and your loved ones.',
                  defination:
                      'We understand the unpredictability of life, but that shouldn’t hinder your well-being. With our comprehensive emergency support service, we’ll ensure holistic care for you. From sickness to health, here are the promises we intend to deliver'),
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
              const TitleDescriptComponent(
                title: 'Health Coach',
                description:
                    'Dedicated SilverGenie Digital Health coach & Physical health coach.',
              ),
              const TitleDescriptComponent(
                title: 'PHR',
                description:
                    'Personal Health record (PHR) creation and regular updating',
              ),
              const TitleDescriptComponent(
                title: 'EPR',
                description:
                    'Emergency Patient Record (EPR) creation and regular updating',
              ),
              const TitleDescriptComponent(
                title: 'Diagnostic support',
                description:
                    'Coordination & support for Diagnostic test medication & allied manpower',
              ),
              const TitleDescriptComponent(
                title: 'Body vitals monitoring',
                description: 'Remote body vitals monitoring',
              ),
              const TitleDescriptComponent(
                title: 'Community',
                description:
                    'Access to the SilverGenie community engagement channel (health & wellbeing)',
              ),
              const TitleDescriptComponent(
                title: 'SG platform',
                description: 'Access to the SilverGenie interactive platform',
              ),
              const SizedBox(
                height: Dimension.d5,
              ),
              Text(
                'SG+ Subscription Plans',
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
                    store.emergencyServiceModel.plans.length,
                    (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              final updatedPlans = List<Plan>.from(
                                  store.emergencyServiceModel.plans);
                              for (int i = 0; i < updatedPlans.length; i++) {
                                updatedPlans[i] = updatedPlans[i]
                                    .copyWith(isSelected: i == index);
                              }
                              store.emergencyServiceModel = store
                                  .emergencyServiceModel
                                  .copyWith(plans: updatedPlans);
                            });
                          },
                          child: PlanDisplayComponent(
                            planPriceDetails: null,
                            isSelected: false,
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
                ontap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const BackToHomeBottomSheetComp(
                            sheetname: 'SG+ Subscription plans',
                            title: 'Your request has been received',
                            description:
                                'Thank you for your interest. The SG team will be in touch with you shortly');
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimension.d3)),
                      constraints: const BoxConstraints(maxHeight: 368));
                },
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
