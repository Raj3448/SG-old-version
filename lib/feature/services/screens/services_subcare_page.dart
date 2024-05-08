import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/search_textfield_componet.dart';
import 'package:silver_genie/feature/services/screens/services_screen.dart';

class ServicesCareScreen extends StatefulWidget {
  ServicesCareScreen({
    Key? key,
    required this.pagetitle,
    required this.isConvenience,
  }) : super(key: key);

  final String pagetitle;
  final bool isConvenience;

  @override
  _ServicesCareScreenState createState() => _ServicesCareScreenState();
}

class _ServicesCareScreenState extends State<ServicesCareScreen> {
  late List<ServicesData> allServices;
  late List<ServicesData> displayedServices;

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allServices = [
      ServicesData(
        imagePath: 'assets/icon/doctor 1.png',
        title: 'Critical nurse care',
        subtitle: 'Description of service will be shown in 2 lines',
      ),
      ServicesData(
                imagePath: 'assets/icon/doctor 1.png',
                title: 'Critical nurse care',
                subtitle: 'Discription of service will be shown in 2 line',
              ),
              ServicesData(
                imagePath: 'assets/icon/doctor-consultation 1.png',
                title: 'General duty attendant',
                subtitle: 'Discription of service will be shown in 2 line',
              ),
              ServicesData(
                imagePath: 'assets/icon/health-insurance 1.png',
                title: 'Nurse',
                subtitle: 'Discription of service will be shown in 2 line',
              ),
              ServicesData(
                imagePath: 'assets/icon/doctor 1.png',
                title: 'Doctor Consultation',
                subtitle: 'Discription of service will be shown in 2 line',
              ),
              ServicesData(
                imagePath: 'assets/icon/doctor-consultation 1.png',
                title: 'General duty attendant',
                subtitle: 'Discription of service will be shown in 2 line',
              ),
              ServicesData(
                imagePath: 'assets/icon/health-insurance 1.png',
                title: 'Nurse',
                subtitle: 'Discription of service will be shown in 2 line',
              ),
      
    ];
    displayedServices = List.from(allServices);
  }

  void filterServices(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedServices = List.from(allServices);
      } else {
        displayedServices = allServices
            .where((service) =>
                service.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(title: widget.pagetitle),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimension.d4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchTextfieldComponet(
                textEditingController: textEditingController,
                onChanged: filterServices,
              ),
              const SizedBox(height: Dimension.d5),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedServices.length,
                itemBuilder: (context, index) {
                  return ServicesListTileComponent(
                    imagePath: displayedServices[index].imagePath,
                    title: displayedServices[index].title,
                    subtitle: displayedServices[index].subtitle,
                  );
                },
              ),
              if (widget.isConvenience) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'For other services & enquiries',
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimension.d2),
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
                            style: AppTextStyle.bodyMediumMedium.copyWith(
                                height: 2, color: AppColors.grayscale900),
                          ),
                          SizedBox(
                            width: 120,
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ServicesData {
  final String imagePath;
  final String title;
  final String subtitle;

  ServicesData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}
