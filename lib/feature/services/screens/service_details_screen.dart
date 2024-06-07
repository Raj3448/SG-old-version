// ignore_for_file: lines_longer_than_80_chars

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/genie_overview.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/services/product_listing_services.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({
    required this.id,
    required this.title,
    super.key,
  });

  final String id;
  final String title;

  @override
  Widget build(BuildContext context) {
    final service = GetIt.I<ProductLisitingServices>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PageAppbar(title: title),
      body: FutureBuilder<Either<Failure, ProductListingModel>>(
        future: service.getProductById(id: id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget(showShadow: false));
          }
          if (snapshot.hasError) {
            return const Center(
              child: ErrorStateComponent(errorType: ErrorType.pageNotFound),
            );
          }
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return data.fold(
              (failure) => const ErrorStateComponent(
                  errorType: ErrorType.somethinWentWrong),
              (product) {
                final serviceData = product.product;
                final allServiceList = <dynamic>[];

                for (final component in serviceData.serviceContent!) {
                  if (component['__component'] ==
                      'service-components.service-description') {
                    allServiceList.add(
                      HeaderModel.fromJson(
                        component as Map<String, dynamic>,
                      ),
                    );
                  }
                  if (component['__component'] ==
                      'service-components.offerings') {
                    allServiceList.add(
                      ServiceOfferingModel.fromJson(
                        component as Map<String, dynamic>,
                      ),
                    );
                  }
                  if (component['__component'] ==
                      'service-components.service-faq') {
                    allServiceList.add(
                      FaqModelDetails.fromJson(
                        component as Map<String, dynamic>,
                      ),
                    );
                  }
                }

                final widgetList = <Widget>[];
                for (final component in allServiceList) {
                  if (component is HeaderModel) {
                    widgetList.add(_HeaderPicTitle(headerModel: component));
                    continue;
                  }
                  if (component is ServiceOfferingModel) {
                    widgetList.add(_Offerings(serviceOfferingModel: component));
                    continue;
                  }
                  if (component is FaqModelDetails) {
                    widgetList.add(
                      FAQComponent(
                        heading: component.label,
                        faqList: component.faq,
                      ),
                    );
                    continue;
                  }
                }

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widgetList,
                          ),
                        ),
                      ),
                    ),
                    if (serviceData.category == 'homeCare')
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, -4),
                              blurRadius: 4,
                              color: AppColors.black.withOpacity(0.15),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              ontap: () {},
                              title: 'Request call back',
                              showIcon: false,
                              iconPath: AppIcons.add,
                              size: ButtonSize.normal,
                              type: ButtonType.secondary,
                              expanded: false,
                              iconColor: AppColors.primary,
                            ),
                            CustomButton(
                              ontap: () {},
                              title: 'Book now',
                              showIcon: false,
                              iconPath: AppIcons.add,
                              size: ButtonSize.normal,
                              type: ButtonType.primary,
                              expanded: false,
                              iconColor: AppColors.primary,
                            ),
                          ],
                        ),
                      )
                    else
                      FixedButton(
                        ontap: () {},
                        btnTitle: 'Book appointment',
                        showIcon: false,
                        iconPath: AppIcons.add,
                      ),
                  ],
                );
              },
            );
          }
          return const Center(child: Text('No data found'));
        },
      ),
    );
  }
}

class _HeaderPicTitle extends StatelessWidget {
  const _HeaderPicTitle({
    required this.headerModel,
  });

  final HeaderModel headerModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl:
                      '${Env.serverUrl}${headerModel.serviceImage.data.attributes.url}',
                ),
              ),
              const SizedBox(height: Dimension.d4),
              Text(headerModel.heading, style: AppTextStyle.bodyXLMedium),
            ],
          ),
        ),
        const SizedBox(height: Dimension.d3),
        Text(
          headerModel.description,
          style: AppTextStyle.bodyLargeMedium
              .copyWith(color: AppColors.grayscale700),
        ),
        const SizedBox(height: Dimension.d4),
      ],
    );
  }
}

class _Offerings extends StatelessWidget {
  const _Offerings({required this.serviceOfferingModel});

  final ServiceOfferingModel serviceOfferingModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(serviceOfferingModel.label, style: AppTextStyle.bodyXLMedium),
        const SizedBox(height: Dimension.d3),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: serviceOfferingModel.offerings.length,
          itemBuilder: (context, index) {
            return _OfferTile(serviceOfferingModel.offerings[index].value);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: Dimension.d1);
          },
        ),
        const SizedBox(height: Dimension.d4),
      ],
    );
  }
}

class _OfferTile extends StatelessWidget {
  const _OfferTile(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          children: [
            SizedBox(height: 6),
            Icon(
              AppIcons.check,
              color: AppColors.primary,
              size: 12,
            ),
          ],
        ),
        const SizedBox(width: Dimension.d3),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.85,
          child: Text(
            title,
            style: AppTextStyle.bodyMediumMedium
                .copyWith(color: AppColors.grayscale700),
          ),
        ),
      ],
    );
  }
}
