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
  const EmergencyServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              height: 400,
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
            )
          ],
        ).paddingSymmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}

