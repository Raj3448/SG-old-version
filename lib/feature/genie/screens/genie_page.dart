// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/back_to_home_component.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/genie_overview.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/dummy_variables.dart';

class GeniePage extends StatelessWidget {
  const GeniePage({
    required this.pageTitle,
    required this.definition,
    required this.headline,
    super.key,
  });
  final String pageTitle;

  final String definition;

  final String headline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(title: pageTitle),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GenieOverviewComponent(
                title: pageTitle,
                headline: headline,
                defination: definition,
              ),
              ServiceProvideComponent(
                serviceDetailsList: servicesList,
              ),
              const SizedBox(
                height: Dimension.d4,
              ),
              PlanPricingDetailsComponent(
                planName: pageTitle,
              ),
              CustomButton(
                ontap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const InfoDialog(
                        showIcon: true,
                        title: 'Your request has been received',
                        desc:
                            'Thank you for your interest. The SG team will be in touch with you shortly.',
                        btnTitle: 'Back to Home',
                        showBtnIcon: false,
                        btnIconPath: AppIcons.arrow_back_ios,
                      );
                    },
                  );
                },
                title: 'Book Care',
                showIcon: false,
                iconPath: AppIcons.add,
                size: ButtonSize.normal,
                type: ButtonType.primary,
                expanded: true,
                iconColor: AppColors.white,
              ),
              ExploreNowComponent(
                pageTitle: pageTitle,
              ),
              HowItWorkComponent(
                questionsAndContentList: questionAndAnswerList,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
