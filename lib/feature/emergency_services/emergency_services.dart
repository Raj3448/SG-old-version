import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/fonts.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/plan_display_component.dart';
import 'package:silver_genie/core/widgets/title_descript_component.dart';
import 'package:silver_genie/feature/emergency_services/store/emergency_service_store.dart';
import 'package:zapx/zapx.dart';

class EmergencyServices extends StatelessWidget {
  EmergencyServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String temp =
        'jhsjhs ssjhsjhsjsd sdssjss s ssjshs sjhshjw wwkwjwkw wkjwkwj tgtgghtrr tttryty ttrtt ttt tggfgrgrgregergregregregregregreregree  gggrg rgrgre r rrsss segesge';
    final EmergencyServiceStore emergencyServiceStore =
        GetIt.instance.get<EmergencyServiceStore>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFFFFFF),
        title: const Text(
          'Emergency services',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Emergency Services',
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColors.grayscale900,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.46,
                )),
            const SizedBox(
              height: Dimension.d1,
            ),
            Text(
                'Stay prepared with our emergency services. We\'re here for you during health scares.',
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColors.grayscale700,
                  fontSize: 14,
                  height: 1.46,
                )),
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
            Text('What is emergency services?',
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColors.grayscale900,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.46,
                )),
            const SizedBox(
              height: Dimension.d1,
            ),
            Text(emergencyServiceStore.emergencyServiceModel.defination,
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColors.grayscale700,
                  fontSize: 14,
                  height: 1.46,
                )),
            const SizedBox(
              height: Dimension.d4,
            ),
            Text('Services we provide',
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColors.grayscale900,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.46,
                )),
            const SizedBox(
              height: Dimension.d5,
            ),
            TitleDescriptComponent(
                title: 'Preparedness Support',
                description: emergencyServiceStore
                    .emergencyServiceModel.support.preparedness),
            const SizedBox(
              height: Dimension.d2,
            ),
            TitleDescriptComponent(
                title: 'Hospital Support',
                description: emergencyServiceStore
                    .emergencyServiceModel.support.hospital),
            const SizedBox(
              height: Dimension.d2,
            ),
            TitleDescriptComponent(
                title: 'Post-discharge Support',
                description: emergencyServiceStore
                    .emergencyServiceModel.support.postDischarge),
            const SizedBox(
              height: Dimension.d2,
            ),
            TitleDescriptComponent(
                title: 'Health-monitoring Support',
                description: emergencyServiceStore
                    .emergencyServiceModel.support.healthMonitor),
            const SizedBox(
              height: Dimension.d2,
            ),
            TitleDescriptComponent(
                title: 'Genie Care Support',
                description: emergencyServiceStore
                    .emergencyServiceModel.support.genieCare),
            const SizedBox(
              height: Dimension.d5,
            ),
            Text('Emergency Service Plans',
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  fontFamily: FontFamily.plusJakarta,
                  color: AppColors.grayscale900,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.46,
                )),
            const SizedBox(
              height: Dimension.d5,
            ),
            Text(emergencyServiceStore.emergencyServiceModel.plansDescription,
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColors.grayscale700,
                  fontSize: 14,
                  height: 1.46,
                )),
            const SizedBox(
              height: Dimension.d4,
            ),
            SizedBox(
              height: 380,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      emergencyServiceStore.emergencyServiceModel.plans.length,
                  itemBuilder: (context, index) {
                    return PlanDisplayComponent(
                            plan: emergencyServiceStore
                                .emergencyServiceModel.plans[index])
                        .paddingOnly(bottom: 10);
                  }),
            ),
            Text('How It works?',
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColors.grayscale700,
                  fontSize: 20,
                  fontFamily: FontFamily.inter,
                  fontWeight: FontWeight.w600,
                  height: 2.514,
                )),
            ExpandingWidget(
                temp: temp, question: 'We will require some important'),
            ExpandingWidget(
                temp: temp,
                question: 'Our genie can get on a call with you, or'),
            ExpandingWidget(
                temp: temp, question: 'Once we have set up the emergency '),
            ExpandingWidget(
                temp: temp, question: 'Please note that our emergency'),
            const SizedBox(
              height: Dimension.d4,
            ),
            Center(
              child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: const MaterialStatePropertyAll(Size(328, 50)),
                    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    backgroundColor:
                        const MaterialStatePropertyAll(AppColors.primary),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Contact Genie',
                    style: AppTextStyle.bodyMediumMedium.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: FontFamily.inter,
                      fontWeight: FontWeight.w500,
                      height: 2.514,
                    ),
                  )),
            ),
            const SizedBox(
              height: Dimension.d4,
            ),
          ],
        ).paddingSymmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}

class ExpandingWidget extends StatefulWidget {
  final String question;
  final String temp;
  const ExpandingWidget({Key? key, required this.question, required this.temp})
      : super(key: key);

  @override
  State<ExpandingWidget> createState() => _ExpandingWidgetState();
}

class _ExpandingWidgetState extends State<ExpandingWidget> {
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
                          ? widget.question + widget.temp
                          : widget.question,
                      style: AppTextStyle.bodyMediumMedium.copyWith(
                          color: AppColors.grayscale700,
                          fontSize: 16,
                          fontFamily: FontFamily.inter,
                          fontWeight: FontWeight.w400,
                          overflow: isExpanding ? null : TextOverflow.ellipsis,
                          height: 2.4)),
                ),
                const Spacer(),
                Image.asset(
                  'assets/icon/Frame.png',
                  height: 20,
                ).paddingOnly(top: 10),
              ],
            ),
          ),
        ),
        const Divider()
      ],
    );
  }
}
