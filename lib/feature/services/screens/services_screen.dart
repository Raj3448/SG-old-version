// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/search_textfield_componet.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final store = GetIt.I<ProductListingStore>();
  late List<ProductBasicDetailsModel> allServices;
  late List<ProductBasicDetailsModel> displayedServices;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allServices = [
      ...store.getHomeCareServicesList,
      ...store.getHealthCareServicesList,
      ...store.getConvenienceCareServicesList,
    ];
    displayedServices = List.from(allServices);

    textEditingController.addListener(() {
      filterServices(textEditingController.text);
    });
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

  void onServiceTap(String id) {
    store.fetchProductById(id).then((_) {
      if (store.selectedProduct != null) {
        GoRouter.of(context).pushNamed(
          RoutesConstants.serviceDetailsScreen,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(store.getProductFailure ?? 'Error')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Observer(
            builder: (context) {
              final homeCareServices = store.getHomeCareServicesList;
              final healthCareServices = store.getHealthCareServicesList;
              final convenienceCareServices =
                  store.getConvenienceCareServicesList;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimension.d5),
                  Text(
                    'Services'.tr(),
                    style: AppTextStyle.bodyXLBold
                        .copyWith(color: AppColors.grayscale900),
                  ),
                  const SizedBox(height: Dimension.d3),
                  SearchTextfield(
                    textEditingController: textEditingController,
                    onChanged: filterServices,
                  ),
                  const SizedBox(height: Dimension.d3),
                  if (textEditingController.text.isEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (homeCareServices.isNotEmpty)
                          _ServiceCategorySection(
                            title: 'Home Care',
                            services: homeCareServices.take(3).toList(),
                            onTapViewAll: () {
                              context.pushNamed(
                                RoutesConstants.allServicesScreen,
                                pathParameters: {
                                  'isConvenience': 'false',
                                  'isHealthCare': 'false',
                                  'isHomeCare': 'true',
                                },
                              );
                            },
                            onServiceTap: onServiceTap,
                          ),
                        if (healthCareServices.isNotEmpty)
                          _ServiceCategorySection(
                            title: 'Health Care',
                            services: healthCareServices.take(3).toList(),
                            onTapViewAll: () {
                              context.pushNamed(
                                RoutesConstants.allServicesScreen,
                                pathParameters: {
                                  'isConvenience': 'false',
                                  'isHealthCare': 'true',
                                  'isHomeCare': 'false',
                                },
                              );
                            },
                            onServiceTap: onServiceTap,
                          ),
                        if (convenienceCareServices.isNotEmpty)
                          _ServiceCategorySection(
                            title: 'Convenience Care',
                            services: convenienceCareServices.take(3).toList(),
                            onTapViewAll: () {
                              context.pushNamed(
                                RoutesConstants.allServicesScreen,
                                pathParameters: {
                                  'isConvenience': 'true',
                                  'isHealthCare': 'false',
                                  'isHomeCare': 'false',
                                },
                              );
                            },
                            onServiceTap: onServiceTap,
                          ),
                      ],
                    )
                  else
                    _ServiceListView(
                      services: displayedServices,
                      getImagePath: (value) =>
                          value.attributes.icon.data.attributes.url,
                      getTitle: (value) => value.attributes.name,
                      getSubtitle: (value) =>
                          value.attributes.metadata.first.value,
                      onServiceTap: onServiceTap,
                    ),
                  const SizedBox(height: Dimension.d6),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ServiceCategorySection extends StatelessWidget {
  const _ServiceCategorySection({
    required this.title,
    required this.services,
    required this.onTapViewAll,
    required this.onServiceTap,
  });

  final String title;
  final List<ProductBasicDetailsModel> services;
  final VoidCallback onTapViewAll;
  final void Function(String) onServiceTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TitleViewAll(
          title: title,
          ontap: onTapViewAll,
        ),
        _ServiceListView(
          services: services,
          getImagePath: (value) => value.attributes.icon.data.attributes.url,
          getTitle: (value) => value.attributes.name,
          getSubtitle: (value) => value.attributes.metadata.first.value,
          onServiceTap: onServiceTap,
        ),
      ],
    );
  }
}

class _TitleViewAll extends StatelessWidget {
  const _TitleViewAll({required this.title, required this.ontap});

  final String title;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.tr(),
          style: AppTextStyle.bodyLargeBold
              .copyWith(color: AppColors.grayscale900),
        ),
        const Spacer(),
        TextButton(
          onPressed: ontap,
          child: Text(
            'View all'.tr(),
            style: AppTextStyle.bodyLargeMedium
                .copyWith(color: AppColors.grayscale600),
          ),
        ),
      ],
    );
  }
}

class _ServiceListView extends StatelessWidget {
  const _ServiceListView({
    required this.services,
    required this.getImagePath,
    required this.getTitle,
    required this.getSubtitle,
    required this.onServiceTap,
  });

  final List<ProductBasicDetailsModel> services;
  final String Function(ProductBasicDetailsModel) getImagePath;
  final String Function(ProductBasicDetailsModel) getTitle;
  final String Function(ProductBasicDetailsModel) getSubtitle;
  final void Function(String) onServiceTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: services.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            onServiceTap('${services[index].id}');
          },
          child: ServicesListTileComponent(
            imagePath: getImagePath(services[index]),
            title: getTitle(services[index]),
            subtitle: getSubtitle(services[index]),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16);
      },
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
              padding: const EdgeInsets.all(10),
              height: 64,
              width: 64,
              child: CachedNetworkImage(
                imageUrl: '${Env.serverUrl}$imagePath',
                fit: BoxFit.cover,
              ),
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
                    style: AppTextStyle.bodyLargeBold
                        .copyWith(color: AppColors.grayscale900),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyle.bodyMediumMedium
                        .copyWith(color: AppColors.grayscale600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
