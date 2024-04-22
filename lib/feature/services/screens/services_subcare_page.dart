import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
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
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SearchTextfieldComponet(),
              SizedBox(
                height: Dimension.d5,
              ),
              ServicesListTileComponent(
                imagePath: 'assets/icon/doctor 1.png',
                title: 'Critical nurse care',
                subtitle: 'Discription of service will be shown in 2 line',
              ),
              ServicesListTileComponent(
                imagePath: 'assets/icon/doctor-consultation 1.png',
                title: 'General duty attendant',
                subtitle: 'Discription of service will be shown in 2 line',
              ),
              ServicesListTileComponent(
                imagePath: 'assets/icon/health-insurance 1.png',
                title: 'Nurse',
                subtitle: 'Discription of service will be shown in 2 line',
              ),
              ServicesListTileComponent(
                imagePath: 'assets/icon/doctor 1.png',
                title: 'Doctor Consultation',
                subtitle: 'Discription of service will be shown in 2 line',
              ),
              ServicesListTileComponent(
                imagePath: 'assets/icon/doctor-consultation 1.png',
                title: 'General duty attendant',
                subtitle: 'Discription of service will be shown in 2 line',
              ),
              ServicesListTileComponent(
                imagePath: 'assets/icon/health-insurance 1.png',
                title: 'Nurse',
                subtitle: 'Discription of service will be shown in 2 line',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
