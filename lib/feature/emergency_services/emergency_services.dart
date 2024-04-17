import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/fonts.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/plan_display_component.dart';
import 'package:silver_genie/core/widgets/title_descript_component.dart';
import 'package:silver_genie/feature/emergency_services/store/emergency_service_store.dart';

class EmergencyServices extends StatelessWidget {
  EmergencyServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String temp =
        'jhsjhs ssjhsjhsjsd sdssjss s ssjshs sjhshjw wwkwjwkw wkjwkwj tgtgghtrr tttryty ttrtt ttt tggfgrgrgregergregregregregregreregree  gggrg rgrgre r rrsss segesge';
    final store = GetIt.I<EmergencyServiceStore>();
    return Scaffold(
      appBar: const PageAppbar(title: 'Emergency services'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              Text(store.emergencyServiceModel.defination,
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
                  description:
                      store.emergencyServiceModel.support.preparedness),
              const SizedBox(
                height: Dimension.d2,
              ),
              TitleDescriptComponent(
                  title: 'Hospital Support',
                  description: store.emergencyServiceModel.support.hospital),
              const SizedBox(
                height: Dimension.d2,
              ),
              TitleDescriptComponent(
                  title: 'Post-discharge Support',
                  description:
                      store.emergencyServiceModel.support.postDischarge),
              const SizedBox(
                height: Dimension.d2,
              ),
              TitleDescriptComponent(
                  title: 'Health-monitoring Support',
                  description:
                      store.emergencyServiceModel.support.healthMonitor),
              const SizedBox(
                height: Dimension.d2,
              ),
              TitleDescriptComponent(
                  title: 'Genie Care Support',
                  description: store.emergencyServiceModel.support.genieCare),
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
              Text(store.emergencyServiceModel.plansDescription,
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
                    itemCount: store.emergencyServiceModel.plans.length,
                    itemBuilder: (context, index) {
                      return PlanDisplayComponent(
                          plan: store.emergencyServiceModel.plans[index]);
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
              CustomButton(
                ontap: () {},
                title: 'Contact Genie',
                showIcon: false,
                iconPath: AppIcons.add,
                size: ButtonSize.normal,
                type: ButtonType.primary,
                expanded: true,
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
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.asset(
                    'assets/icon/Frame.png',
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider()
      ],
    );
  }
}
