import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/search_textfield_componet.dart';
import 'package:silver_genie/feature/services/screens/services_screen.dart';

class ServicesCareScreen extends StatelessWidget {
  const ServicesCareScreen({required this.pagetitle, super.key});
  final String pagetitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(title: pagetitle),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimension.d4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchTextfieldComponet(),
              const SizedBox(
                height: Dimension.d5,
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
              const ServicesListTileComponent(
                imagePath: 'assets/icon/doctor 1.png',
                title: 'Doctor Consultation',
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
              Text(
                'For other services & enquires',
                style: AppTextStyle.bodyLargeMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 2.4,
                  color: AppColors.grayscale900,
                ),
              ),
              Container(
                height: 56,
                margin: const EdgeInsets.only(
                  bottom: Dimension.d4,
                  top: Dimension.d2,
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimension.d2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primary,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Contact SilverGenie team',
                      style: AppTextStyle.bodyMediumMedium
                          .copyWith(height: 2, color: AppColors.grayscale900),
                    ),
                    SizedBox(
                      width: 110,
                      height: 40,
                      child: CustomButton(
                        ontap: () {},
                        title: 'Call now',
                        showIcon: false,
                        iconPath: AppIcons.add,
                        size: ButtonSize.values[0],
                        type: ButtonType.primary,
                        expanded: true,
                        iconColor: AppColors.white,
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
