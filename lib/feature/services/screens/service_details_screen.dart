// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/services/repo/services_repo.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({
    required this.imgPath,
    required this.name,
    required this.yoe,
    required this.type,
    required this.docInfo,
    required this.hospital,
    required this.charges,
    super.key,
  });

  final String imgPath;
  final String name;
  final String yoe;
  final String type;
  final String docInfo;
  final String hospital;
  final String charges;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PageAppbar(title: 'Doctor details'),
      body: FutureBuilder(
        future: fetchDocDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          } else if (snapshot.hasError) {
            // TODO(Amanjot): update this with the new error screens.
            return Text('Error: ${snapshot.error}');
          } else {
            final doctor = snapshot.data!;
            return Scaffold(
              backgroundColor: AppColors.white,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FixedButton(
                ontap: () {
                  GoRouter.of(context).push(RoutesConstants.bookServiceScreen);
                },
                btnTitle: 'Book appointment',
                showIcon: false,
                iconPath: AppIcons.add,
              ),
              body: ListView.builder(
                itemCount: doctor.length,
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                itemBuilder: (context, index) {
                  final doctorInfo = doctor[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        doctorInfo.imgPath,
                        scale: 0.8,
                      ),
                      const SizedBox(height: Dimension.d3),
                      Center(
                        child: Text(
                          'Dr. ${doctorInfo.name}',
                          style: AppTextStyle.bodyXLBold
                              .copyWith(color: AppColors.grayscale900),
                        ),
                      ),
                      const SizedBox(height: Dimension.d4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            AppIcons.medical_services,
                            color: AppColors.grayscale700,
                            size: 18,
                          ),
                          const SizedBox(width: Dimension.d2),
                          Text(
                            '${doctorInfo.yoe} Years',
                            style: AppTextStyle.bodyMediumMedium
                                .copyWith(color: AppColors.grayscale800),
                          ),
                          const SizedBox(width: Dimension.d4),
                          const Icon(
                            Icons.favorite_border,
                            color: AppColors.grayscale700,
                            size: 18,
                          ),
                          const SizedBox(width: Dimension.d2),
                          Text(
                            doctorInfo.type,
                            style: AppTextStyle.bodyMediumMedium
                                .copyWith(color: AppColors.grayscale800),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimension.d6),
                      Text(
                        'Doctor Information',
                        style: AppTextStyle.bodyXLBold
                            .copyWith(color: AppColors.grayscale900),
                      ),
                      const SizedBox(height: Dimension.d2),
                      Text(
                        doctorInfo.info,
                        style: AppTextStyle.bodyLargeMedium
                            .copyWith(color: AppColors.grayscale700),
                      ),
                      const SizedBox(height: Dimension.d6),
                      Text(
                        'Hospital',
                        style: AppTextStyle.bodyXLBold
                            .copyWith(color: AppColors.grayscale900),
                      ),
                      const SizedBox(height: Dimension.d2),
                      Row(
                        children: [
                          // TODO(Amanjot): Update the icons consts file once all icons are added and replace this icon.
                          const Icon(
                            Icons.share_location,
                            color: AppColors.grayscale700,
                          ),
                          const SizedBox(width: Dimension.d3),
                          Text(
                            doctorInfo.hospital,
                            style: AppTextStyle.bodyLargeMedium
                                .copyWith(color: AppColors.grayscale700),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimension.d6),
                      Text(
                        'Consultation charges',
                        style: AppTextStyle.bodyXLBold
                            .copyWith(color: AppColors.grayscale900),
                      ),
                      const SizedBox(height: Dimension.d2),
                      Row(
                        children: [
                          // TODO(Amanjot): Update the icons consts file once all icons are added and replace this icon.
                          const Icon(
                            Icons.money_rounded,
                            color: AppColors.grayscale700,
                          ),
                          const SizedBox(width: Dimension.d3),
                          Text(
                            '₹ ${doctorInfo.charges}/hr',
                            style: AppTextStyle.bodyLargeMedium
                                .copyWith(color: AppColors.grayscale700),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimension.d6),
                      Text(
                        'Expertise Skill',
                        style: AppTextStyle.bodyXLBold
                            .copyWith(color: AppColors.grayscale900),
                      ),
                      const SizedBox(height: Dimension.d2),
                      SizedBox(
                        width: 300,
                        child: Center(
                          child: GridView.builder(
                            itemCount: doctorInfo.expertise.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 180,
                              mainAxisExtent: 30,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: _InfoTile(doctorInfo.expertise[index]),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimension.d6),
                      Text(
                        'Preferred language',
                        style: AppTextStyle.bodyXLBold
                            .copyWith(color: AppColors.grayscale900),
                      ),
                      const SizedBox(height: Dimension.d2),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Center(
                          child: GridView.builder(
                            itemCount: doctorInfo.expertise.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 80,
                              mainAxisExtent: 30,
                            ),
                            itemBuilder: (context, index) {
                              return Center(
                                child:
                                    _InfoTile(doctorInfo.preferredLang[index]),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimension.d6),
                      Text(
                        'How will this service work?',
                        style: AppTextStyle.bodyXLBold
                            .copyWith(color: AppColors.grayscale900),
                      ),
                      const SizedBox(height: Dimension.d2),
                      const Text(
                        'Step 1',
                        style: AppTextStyle.bodyLargeMedium,
                      ),
                      const SizedBox(height: Dimension.d1),
                      Text(
                        'Select a doctor matching your requirement',
                        style: AppTextStyle.bodyMediumMedium
                            .copyWith(color: AppColors.grayscale700),
                      ),
                      const SizedBox(height: Dimension.d3),
                      const Text(
                        'Step 2',
                        style: AppTextStyle.bodyLargeMedium,
                      ),
                      const SizedBox(height: Dimension.d1),
                      Text(
                        'Check available time slots and select which one works for you',
                        style: AppTextStyle.bodyMediumMedium
                            .copyWith(color: AppColors.grayscale700),
                      ),
                      const SizedBox(height: Dimension.d3),
                      const Text(
                        'Step 3',
                        style: AppTextStyle.bodyLargeMedium,
                      ),
                      const SizedBox(height: Dimension.d1),
                      Text(
                        'Confirm your booking',
                        style: AppTextStyle.bodyMediumMedium
                            .copyWith(color: AppColors.grayscale700),
                      ),
                      const SizedBox(height: Dimension.d3),
                      const Text(
                        'Step 4',
                        style: AppTextStyle.bodyLargeMedium,
                      ),
                      const SizedBox(height: Dimension.d1),
                      Text(
                        'Doctor will be at your home for the service',
                        style: AppTextStyle.bodyMediumMedium
                            .copyWith(color: AppColors.grayscale700),
                      ),
                      const SizedBox(height: Dimension.d20),
                    ],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(100),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        title,
        style: AppTextStyle.bodySmallMedium
            .copyWith(color: AppColors.grayscale900),
      ),
    );
  }
}
