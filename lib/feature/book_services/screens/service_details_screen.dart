// ignore_for_file: lines_longer_than_80_chars, inference_failure_on_function_invocation

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/banner_network_img_component.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/contact_sg_team_component.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/genie_overview.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/model/service_banner_image.dart';
import 'package:silver_genie/feature/book_services/screens/booking_payment_detail_screen.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/services/product_listing_services.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({
    required this.id,
    required this.title,
    required this.productCode,
    super.key,
  });

  final String id;
  final String title;
  final String productCode;

  @override
  Widget build(BuildContext context) {
    final service = GetIt.I<ProductListingServices>();
    final store = GetIt.I<ProductListingStore>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PageAppbar(title: title),
        body: FutureBuilder<Either<Failure, ProductListingModel>>(
          future: service.getProductById(id: id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingWidget(showShadow: false),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: ErrorStateComponent(
                  errorType: ErrorType.pageNotFound,
                ),
              );
            }
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return data.fold(
                (failure) => const ErrorStateComponent(
                  errorType: ErrorType.somethinWentWrong,
                ),
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
                    if (component['__component'] ==
                        'service-components.service-price') {
                      allServiceList.add(
                        ServicePriceModel.fromJson(
                          component as Map<String, dynamic>,
                        ),
                      );
                    }
                    if (component['__component'] ==
                        'service-components.banner') {
                      allServiceList.add(
                        ServiceBannerImage.fromJson(
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
                      widgetList.add(
                        _Offerings(serviceOfferingModel: component),
                      );
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
                    if (component is ServiceBannerImage) {
                      if (component.isActive) {
                        widgetList.addAll([
                          Text(
                            component.label,
                            style: AppTextStyle.bodyXLBold.copyWith(
                                color: AppColors.grayscale900, height: 2),
                          ),
                          const SizedBox(
                            height: Dimension.d2,
                          ),
                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => GestureDetector(
                                    onTap: () async {
                                      if (component.cta != null) {
                                        if (component.cta!.isExternal &&
                                            await canLaunchUrl(Uri.parse(
                                                component.cta!.href))) {
                                          await launchUrl(
                                              Uri.parse(component.cta!.href));
                                        }
                                      }
                                    },
                                    child: BannerImageComponent(
                                        imageUrl: component.bannerImage
                                            .data[index].attributes.url),
                                  ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: Dimension.d2,
                                  ),
                              itemCount: component.bannerImage.data.length)
                        ]);
                      }
                      continue;
                    }
                    if (component is ServicePriceModel) {
                      widgetList.add(_PriceTile(
                        price:
                            '₹ ${formatNumberWithCommas(component.startPrice)}${component.endPrice == null ? '' : ' - ${formatNumberWithCommas(component.endPrice!)}'}',
                        subscript: component.priceSuperscript,
                        desc: component.priceDescription,
                        label: component.label,
                      ));
                    }
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Observer(
                              builder: (_) {
                                return Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...widgetList,
                                        if (serviceData.category ==
                                            'homeCare') ...[
                                          Text(
                                            'For More enquires',
                                            style: AppTextStyle.bodyXLSemiBold
                                                .copyWith(
                                              height: 2.4,
                                              color: AppColors.grayscale900,
                                            ),
                                          ),
                                          const ContactSgTeamComponent(
                                            phoneNumber: '+91 0000000000',
                                          )
                                        ]
                                      ],
                                    ),
                                    if (store.isLoading) const LoadingWidget(),
                                  ],
                                );
                              },
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
                                ontap: () {
                                  context.pushNamed(
                                    RoutesConstants.bookServiceScreen,
                                    pathParameters: {
                                      'id': id,
                                      'productCode': productCode
                                    },
                                  );
                                },
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
                          ontap: () {
                            store.isLoading = true;
                            final userStore = GetIt.I<UserDetailStore>();
                            service
                                .bookService(
                              name: userStore.userDetails?.name ?? '',
                              phoneNumber:
                                  userStore.userDetails?.phoneNumber ?? '',
                              email: userStore.userDetails?.email ?? '',
                              careType: title,
                            )
                                .then((result) {
                              store.isLoading = false;
                              result.fold(
                                (failure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Service booking failed!',
                                      ),
                                    ),
                                  );
                                },
                                (success) {
                                  showModalBottomSheet(
                                    backgroundColor: AppColors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                          Dimension.d3,
                                        ),
                                        topRight: Radius.circular(
                                          Dimension.d3,
                                        ),
                                      ),
                                    ),
                                    constraints: const BoxConstraints(
                                      maxHeight: 400,
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(18),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '$title service',
                                                  style: AppTextStyle
                                                      .heading5SemiBold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: Dimension.d9,
                                              ),
                                              const Text(
                                                'Your request has been received',
                                                style:
                                                    AppTextStyle.bodyLargeBold,
                                              ),
                                              const SizedBox(
                                                height: Dimension.d3,
                                              ),
                                              SvgPicture.asset(
                                                'assets/icon/success.svg',
                                                height: 88,
                                              ),
                                              const SizedBox(
                                                height: Dimension.d3,
                                              ),
                                              Text(
                                                'Thank you for your interest. The SG team will be in touch with you shortly',
                                                textAlign: TextAlign.center,
                                                style: AppTextStyle
                                                    .bodyMediumMedium
                                                    .copyWith(
                                                  color: AppColors.grayscale700,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: Dimension.d9,
                                              ),
                                              CustomButton(
                                                ontap: () {
                                                  context
                                                    ..pop()
                                                    ..pop();
                                                },
                                                title: 'Done',
                                                showIcon: false,
                                                iconPath: AppIcons.add,
                                                size: ButtonSize.normal,
                                                type: ButtonType.primary,
                                                expanded: true,
                                                iconColor: AppColors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            });
                          },
                          btnTitle: 'Request service',
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl:
                    '${Env.serverUrl}${headerModel.serviceImage.data?.attributes.url}',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: Dimension.d4),
            Center(
              child: Text(
                headerModel.heading,
                style: AppTextStyle.bodyXLMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
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

class _PriceTile extends StatelessWidget {
  const _PriceTile({
    required this.price,
    required this.subscript,
    required this.desc,
    required this.label,
  });

  final String price;
  final String? subscript;
  final String? desc;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.bodyXLBold
              .copyWith(color: AppColors.grayscale900, height: 2),
        ),
        const SizedBox(
          height: Dimension.d2,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(4),
          ),
          margin: const EdgeInsets.only(bottom: Dimension.d2),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    price,
                    style: AppTextStyle.heading4SemiBold.copyWith(
                      color: AppColors.grayscale900,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    subscript ?? '',
                    style: AppTextStyle.bodyMediumMedium.copyWith(
                      color: AppColors.grayscale700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimension.d2),
              Text(
                desc ?? '',
                style: AppTextStyle.bodyLargeMedium.copyWith(
                  color: AppColors.grayscale700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
