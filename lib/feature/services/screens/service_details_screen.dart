// ignore_for_file: lines_longer_than_80_chars

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/genie_overview.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final store = GetIt.I<ProductListingStore>();
  late final serviceData = store.selectedProduct!.product;
  List<dynamic> allServiceList = [];

  @override
  void initState() {
    for (final component in serviceData.serviceContent!) {
      if (component['__component'] ==
          'service-components.service-description') {
        allServiceList.add(
          HeaderModel.fromJson(component as Map<String, dynamic>),
        );
      }
      if (component['__component'] == 'service-components.offerings') {
        allServiceList.add(
          ServiceOfferingModel.fromJson(
            component as Map<String, dynamic>,
          ),
        );
      }
      if (component['__component'] == 'service-components.service-faq') {
        allServiceList.add(
          FaqModelDetails.fromJson(
            component as Map<String, dynamic>,
          ),
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widgetList = <Widget>[];
    for (final component in allServiceList) {
      if (component is HeaderModel) {
        widgetList.add(
          _HeaderPicTitle(headerModel: component),
        );
        continue;
      }
      if (component is ServiceOfferingModel) {
        widgetList.add(
          _Offerings(serviceOfferingModel: component),
        );
        continue;
      }
      if (component is FaqModelDetails) {
        widgetList.add(
          FAQComponent(heading: component.label, faqList: component.faq),
        );
        continue;
      }
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PageAppbar(title: serviceData.name),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...widgetList,
            ],
          ),
        ),
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
        Column(
          children: [
            const SizedBox(height: 6),
            const Icon(
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
