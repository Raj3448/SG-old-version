import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/fonts.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/search_textfield_componet.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<ProductListingStore>();
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
              const SizedBox(height: Dimension.d3),
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
                          'isConvenience': false.toString(),
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
              _ServiceListView(
                store: store.getHomeCareServicesList,
                getImagePath: (value) =>
                    value.attributes.icon.data.attributes.url,
                getTitle: (value) => value.attributes.name,
                subtitle: (value) => value.attributes.name,
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
                          'isConvenience': false.toString(),
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
              _ServiceListView(
                store: store.getHealthCareServicesList,
                getImagePath: (value) =>
                    value.attributes.icon.data.attributes.url,
                getTitle: (value) => value.attributes.name,
                subtitle: (value) => value.attributes.name,
              ),
              Row(
                children: [
                  Text(
                    'Convenience Care'.tr(),
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
                          'isConvenience': false.toString(),
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
              _ServiceListView(
                store: store.getConvenienceCareServicesList,
                getImagePath: (value) =>
                    value.attributes.icon.data.attributes.url,
                getTitle: (value) => value.attributes.name,
                subtitle: (value) => value.attributes.name,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceListView extends StatelessWidget {
  const _ServiceListView({
    required this.store,
    required this.getImagePath,
    required this.getTitle,
    required this.subtitle,
  });

  final List<ProductBasicDetailsModel> store;
  final String Function(ProductBasicDetailsModel) getImagePath;
  final String Function(ProductBasicDetailsModel) getTitle;
  final String Function(ProductBasicDetailsModel) subtitle;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: store.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ServicesListTileComponent(
          imagePath: getImagePath(store[index]),
          title: getTitle(store[index]),
          subtitle: 'subtitle',
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
                child:
                    CachedNetworkImage(imageUrl: '${Env.serverUrl}$imagePath'),
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
