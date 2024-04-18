import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/search_textfield_componet.dart';
import 'package:silver_genie/feature/services/screens/services_screen.dart';

class ServicesCareScreen extends StatelessWidget {
  final String pagetitle;
  const ServicesCareScreen({required this.pagetitle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(title: pagetitle),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimension.d1),
          child: Column(
            children: [
              const SearchTextfieldComponet(),
              const SizedBox(
                height: Dimension.d5,
              ),
              const ServicesListTileComponent(
                  imagePath: 'assets/icon/doctor 1.png',
                  title: 'Critical nurse care',
                  subtitle: 'Discription of service will be shown in 2 line'),
              const ServicesListTileComponent(
                  imagePath: 'assets/icon/doctor-consultation 1.png',
                  title: 'General duty attendant',
                  subtitle: 'Discription of service will be shown in 2 line'),
              const ServicesListTileComponent(
                  imagePath: 'assets/icon/health-insurance 1.png',
                  title: 'Nurse',
                  subtitle: 'Discription of service will be shown in 2 line'),
              const ServicesListTileComponent(
                  imagePath: 'assets/icon/doctor 1.png',
                  title: 'Doctor Consultation',
                  subtitle: 'Discription of service will be shown in 2 line'),
              const ServicesListTileComponent(
                  imagePath: 'assets/icon/doctor-consultation 1.png',
                  title: 'General duty attendant',
                  subtitle: 'Discription of service will be shown in 2 line'),
              const ServicesListTileComponent(
                  imagePath: 'assets/icon/health-insurance 1.png',
                  title: 'Nurse',
                  subtitle: 'Discription of service will be shown in 2 line'),
              Text(
                'For other services & enquires',
                style: AppTextStyle.bodyLargeMedium
                    .copyWith(fontWeight: FontWeight.w500, height: 2.4),
              )
            ],
          ),
        ),
      ),
    );
  }
}
