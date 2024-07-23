// ignore_for_file: library_private_types_in_public_api, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/contact_sg_team_component.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/search_textfield_componet.dart';
import 'package:silver_genie/feature/book_services/screens/services_screen.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';

class AllServicesScreen extends StatefulWidget {
  const AllServicesScreen({
    required this.isConvenience,
    required this.isHomeCare,
    required this.isHealthCare,
    super.key,
  });

  final bool isConvenience;
  final bool isHomeCare;
  final bool isHealthCare;

  @override
  _AllServicesScreenState createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> {
  late List<ProductBasicDetailsModel> allServices;
  late List<ProductBasicDetailsModel> displayedServices;
  final store = GetIt.I<ProductListingStore>();

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allServices = getAllServices();
    displayedServices = List.from(allServices);

    textEditingController.addListener(() {
      filterServices(textEditingController.text);
    });
  }

  List<ProductBasicDetailsModel> getAllServices() {
    if (widget.isConvenience) {
      return store.getConvenienceCareServicesList;
    } else if (widget.isHealthCare) {
      return store.getHealthCareServicesList;
    } else {
      return store.getHomeCareServicesList;
    }
  }

  void filterServices(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedServices = List.from(allServices);
      } else {
        displayedServices = allServices
            .where(
              (service) => service.attributes.name
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PageAppbar(
          title: widget.isConvenience
              ? 'Convenience care services'
              : widget.isHealthCare
                  ? 'Health care services'
                  : 'Home care services',
        ),
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Dimension.d4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchTextfield(
                  textEditingController: textEditingController,
                  onChanged: filterServices,
                ),
                const SizedBox(height: Dimension.d5),
                ListView.separated(
                  itemCount: displayedServices.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          RoutesConstants.serviceDetailsScreen,
                          pathParameters: {
                            'id': '${displayedServices[index].id}',
                            'title': displayedServices[index].attributes.name,
                            'productCode':
                                displayedServices[index].attributes.code,
                          },
                        );
                      },
                      child: ServicesListTileComponent(
                        imagePath: displayedServices[index]
                            .attributes
                            .icon
                            .data
                            .attributes
                            .url,
                        title: displayedServices[index].attributes.name,
                        subtitle: displayedServices[index]
                            .attributes
                            .metadata
                            .where((m) => m.key == 'subtitle')
                            .firstOrNull
                            ?.value,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 16);
                  },
                ),
                if (displayedServices.isEmpty)
                  NoServiceFound(
                    title: '',
                    ontap: () {},
                    showTitle: false,
                    isService: true,
                  ),
                if (widget.isConvenience) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimension.d8),
                      Text(
                        'For other services & enquiries',
                        style: AppTextStyle.bodyLargeMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 2.4,
                          color: AppColors.grayscale900,
                        ),
                      ),
                      const ContactSgTeamComponent(
                        phoneNumber: '+91 0000000000',
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ServicesData {
  ServicesData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
  final String imagePath;
  final String title;
  final String subtitle;
}
