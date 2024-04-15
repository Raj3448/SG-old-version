// ignore_for_file: lines_longer_than_80_chars

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/fonts.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';
import 'package:silver_genie/core/widgets/search_textfield_componet.dart';
import 'package:zapx/zapx.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Services'.tr(),
              style: AppTextStyle.bodyMediumMedium.copyWith(
                color: AppColors.grayscale900,
                fontSize: 18,
                height: 2.6,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.inter,
              ),
            ),
            const SizedBox(
              height: Dimension.d3,
            ),
            const SearchTextfieldComponet(),
            const SizedBox(
              height: Dimension.d3,
            ),
            Row(
              children: [
                Text(
                  'Home Care'.tr(),
                  style: AppTextStyle.bodyMediumMedium.copyWith(
                    color: AppColors.grayscale900,
                    fontSize: 16,
                    height: 2.4,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.inter,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.pushNamed(
                      RoutesConstants.servicesCareScreenDisplay,
                      pathParameters: {'pageTitle': 'Home care services'},
                    );
                  },
                  child: Text(
                    'View all'.tr(),
                    style: AppTextStyle.bodyMediumMedium.copyWith(
                      color: AppColors.grayscale600,
                      fontSize: 16,
                      height: 2.4,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.inter,
                    ),
                  ),
                ),
              ],
            ),
            const ServicesListTileComponent(
              imagePath: 'assets/icon/doctor 1.png',
              title: 'Critical nurse care',
              subtitle: 'Discription of service will be shown in 2 line',
            ),
            const ServicesListTileComponent(
              imagePath: 'assets/icon/doctor-consultation 1.png',
              title: 'General duty attendant',
              subtitle: 'Discription of service will be shown in 2 line',
            ),
            const ServicesListTileComponent(
              imagePath: 'assets/icon/health-insurance 1.png',
              title: 'Nurse',
              subtitle: 'Discription of service will be shown in 2 line',
            ),

            Row(
              children: [
                Text(
                  'Health Care'.tr(),
                  style: AppTextStyle.bodyMediumMedium.copyWith(
                    color: AppColors.grayscale900,
                    fontSize: 16,
                    height: 2.4,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.inter,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    context.pushNamed(
                      RoutesConstants.servicesCareScreenDisplay,
                      pathParameters: {
                        'pageTitle': 'Health care services',
                      },
                    );
                  },
                  child: Text(
                    'View all'.tr(),
                    style: AppTextStyle.bodyMediumMedium.copyWith(
                      color: AppColors.grayscale600,
                      fontSize: 16,
                      height: 2.4,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.inter,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                GoRouter.of(context).pushNamed(
                  RoutesConstants.serviceDetailsScreen,
                  pathParameters: {
                    'imgPath': 'assets/icon/doctor.png',
                    'name': 'Kamala harris',
                    'yoe': '15',
                    'type': 'General Practitioner',
                    'docInfo':
                        'Experienced General Practitioner at Oakwood Medical Clinic, committed to providing personalized and holistic healthcare for patients of all ages.',
                    'hospital': 'Apollo Hospital, Chennai',
                    'charges': '₹ 600/hr',
                  },
                );
              },
              child: const ServicesListTileComponent(
                imagePath: 'assets/icon/doctor 1.png',
                title: 'Doctor Consultation',
                subtitle: 'Discription of service will be shown in 2 line',
              ),
            ),
            const ServicesListTileComponent(
              imagePath: 'assets/icon/doctor-consultation 1.png',
              title: 'General duty attendant',
              subtitle: 'Discription of service will be shown in 2 line',
            ),
            const ServicesListTileComponent(
              imagePath: 'assets/icon/health-insurance 1.png',
              title: 'Nurse',
              subtitle: 'Discription of service will be shown in 2 line',
            ),
            //E3E9EC
          ],
        ).paddingSymmetric(horizontal: 20),
      ),
    );
  }
}

class ServicesListTileComponent extends StatelessWidget {
  const ServicesListTileComponent({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    super.key,
  });
  final String imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: const Color(0xffF6F8FF)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffF6F8FF),
              border: Border.all(width: 2, color: const Color(0xffE3E9EC)),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 64,
            width: 64,
            child: Image.asset(imagePath),
          ),
          const SizedBox(
            width: Dimension.d2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColors.grayscale900,
                  fontSize: 16,
                  height: 2,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.inter,
                ),
              ),
              SizedBox(
                width: 250,
                child: Text(
                  subtitle,
                  style: AppTextStyle.bodyMediumMedium.copyWith(
                    color: AppColors.grayscale600,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamily.inter,
                  ),
                ),
              ),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 10, vertical: 10),
    );
  }
}
