import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/genie_overview.dart';
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
                ontap: () {},
                title: 'Book Care',
                showIcon: false,
                iconPath: AppIcons.add,
                size: ButtonSize.normal,
                type: ButtonType.primary,
                expanded: true,
              ),
              ExploreNowComponent(),
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
