import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/back_to_home_component.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/genie_overview.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/dummy_variables.dart';

class GeniePage extends StatelessWidget {
  final String pageTitle;

  final String defination;

  final String headline;

  const GeniePage(
      {required this.pageTitle,
      required this.defination,
      required this.headline,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(title: pageTitle),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GenieOverviewComponent(
                title: pageTitle,
                headline: headline,
                defination: defination,
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
                        return Dialog(
                          insetPadding: const EdgeInsets.symmetric(
                              horizontal: Dimension.d2),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimension.d2)),
                          child: Container(
                              height: 300,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimension.d2),
                              child: const BackToHomeComponent(
                                  title: 'Your request has been received',
                                  description:
                                      'Thank you for your interest. The SG team will be in touch with you shortly')),
                        );
                      });
                },
                title: 'Book Care',
                showIcon: false,
                iconPath: AppIcons.add,
                size: ButtonSize.normal,
                type: ButtonType.primary,
                expanded: true,
              ),
              ExploreNowComponent(
                pageTitle: pageTitle,
              ),
              HowItWorkComponent(
                questionsAndContentList: questionAndAnswerList,
              )
            ],
          ),
        ),
      ),
    );
  }
}
