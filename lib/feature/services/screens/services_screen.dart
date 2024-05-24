import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/fonts.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/search_textfield_componet.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
              SearchTextfieldComponet(
                textEditingController: TextEditingController(),
                onChanged: (String) {},
              ),
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
                        RoutesConstants.servicesCareScreen,
                        pathParameters: {
                          'pageTitle': 'Home care services',
                          'isConvenience': false.toString()
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
                      'imgPath': 'cdsc',
                      'name': 'Critical nurse care',
                      'yoe': 'Critical nurse care',
                      'type': 'Critical nurse care',
                      'docInfo': 'Critical nurse care',
                      'hospital': 'Critical nurse care',
                      'charges': 'Critical nurse care',
                    },
                  );
                },
                child: const ServicesListTileComponent(
                  imagePath: 'assets/icon/doctor 1.png',
                  title: 'Critical nurse care',
                  subtitle: 'Discription of service will be shown in 2 line',
                ),
              ),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(
                    RoutesConstants.serviceDetailsScreen,
                    pathParameters: {
                      'imgPath': 'cdsc',
                      'name': 'Critical nurse care',
                      'yoe': 'Critical nurse care',
                      'type': 'Critical nurse care',
                      'docInfo': 'Critical nurse care',
                      'hospital': 'Critical nurse care',
                      'charges': 'Critical nurse care',
                    },
                  );
                },
                child: const ServicesListTileComponent(
                  imagePath: 'assets/icon/doctor-consultation 1.png',
                  title: 'General duty attendant',
                  subtitle: 'Discription of service will be shown in 2 line',
                ),
              ),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(
                    RoutesConstants.serviceDetailsScreen,
                    pathParameters: {
                      'imgPath': 'cdsc',
                      'name': 'Critical nurse care',
                      'yoe': 'Critical nurse care',
                      'type': 'Critical nurse care',
                      'docInfo': 'Critical nurse care',
                      'hospital': 'Critical nurse care',
                      'charges': 'Critical nurse care',
                    },
                  );
                },
                child: const ServicesListTileComponent(
                  imagePath: 'assets/icon/health-insurance 1.png',
                  title: 'Nurse',
                  subtitle: 'Discription of service will be shown in 2 line',
                ),
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
                        RoutesConstants.servicesCareScreen,
                        pathParameters: {
                          'pageTitle': 'Health care services',
                          'isConvenience': false.toString()
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
                      'imgPath': 'cdsc',
                      'name': 'Critical nurse care',
                      'yoe': 'Critical nurse care',
                      'type': 'Critical nurse care',
                      'docInfo': 'Critical nurse care',
                      'hospital': 'Critical nurse care',
                      'charges': 'Critical nurse care',
                    },
                  );
                },
                child: const ServicesListTileComponent(
                  imagePath: 'assets/icon/doctor 1.png',
                  title: 'Doctor Consultation',
                  subtitle: 'Discription of service will be shown in 2 line',
                ),
              ),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(
                    RoutesConstants.serviceDetailsScreen,
                    pathParameters: {
                      'imgPath': 'cdsc',
                      'name': 'Critical nurse care',
                      'yoe': 'Critical nurse care',
                      'type': 'Critical nurse care',
                      'docInfo': 'Critical nurse care',
                      'hospital': 'Critical nurse care',
                      'charges': 'Critical nurse care',
                    },
                  );
                },
                child: const ServicesListTileComponent(
                  imagePath: 'assets/icon/doctor-consultation 1.png',
                  title: 'General duty attendant',
                  subtitle: 'Discription of service will be shown in 2 line',
                ),
              ),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(
                    RoutesConstants.serviceDetailsScreen,
                    pathParameters: {
                      'imgPath': 'cdsc',
                      'name': 'Critical nurse care',
                      'yoe': 'Critical nurse care',
                      'type': 'Critical nurse care',
                      'docInfo': 'Critical nurse care',
                      'hospital': 'Critical nurse care',
                      'charges': 'Critical nurse care',
                    },
                  );
                },
                child: const ServicesListTileComponent(
                  imagePath: 'assets/icon/health-insurance 1.png',
                  title: 'Nurse',
                  subtitle: 'Discription of service will be shown in 2 line',
                ),
              ),
            ],
          ),
        ),
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
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pushNamed(
          RoutesConstants.serviceDetailsScreen,
          pathParameters: {
            'imgPath': 'cdsc',
            'name': 'Critical nurse care',
            'yoe': 'Critical nurse care',
            'type': 'Critical nurse care',
            'docInfo': 'Critical nurse care',
            'hospital': 'Critical nurse care',
            'charges': 'Critical nurse care',
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: AppColors.secondary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  border: Border.all(width: 2, color: AppColors.grayscale300),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 64,
                width: 64,
                child: Image.asset(imagePath),
              ),
              const SizedBox(
                width: Dimension.d2,
              ),
              Expanded(
                child: Column(
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
                    Text(
                      subtitle,
                      style: AppTextStyle.bodyMediumMedium.copyWith(
                        color: AppColors.grayscale600,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: FontFamily.inter,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
