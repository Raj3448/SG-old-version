// ignore_for_file: inference_failure_on_function_invocation, lines_longer_than_80_chars, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/genie_overview.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/services/product_listing_services.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

class GeniePage extends StatelessWidget {
  GeniePage({
    required this.pageTitle,
    required this.id,
    required this.isUpgradable,
    super.key,
  });

  final String pageTitle;
  final String id;
  final bool isUpgradable;

  final services = GetIt.I<ProductListingServices>();
  final store = GetIt.I<ProductListingStore>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PageAppbar(title: pageTitle),
        backgroundColor: AppColors.white,
        body: FutureBuilder(
          future: services.getProductById(id: id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget(
                showShadow: false,
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const ErrorStateComponent(
                errorType: ErrorType.somethinWentWrong,
              );
            }
            ProductListingModel? productListingModel;
            snapshot.data!.fold((l) {
              return const ErrorStateComponent(
                errorType: ErrorType.somethinWentWrong,
              );
            }, (r) {
              productListingModel = r;
            });

            if (productListingModel == null ||
                productListingModel!.product.subscriptionContent == null) {
              return const ErrorStateComponent(
                errorType: ErrorType.somethinWentWrong,
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
              child: SingleChildScrollView(
                child: Observer(
                  builder: (context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GenieOverviewComponent(
                          title: productListingModel!
                              .product.subscriptionContent!.mainHeading,
                          headline: productListingModel!
                              .product.subscriptionContent!.headingDescription,
                          defination: productListingModel!.product
                              .subscriptionContent!.subHeading1Description,
                          subHeading: productListingModel!
                              .product.subscriptionContent!.subHeading1,
                          imageUrl: productListingModel!
                              .product
                              .subscriptionContent!
                              .productImage!
                              .data
                              .attributes
                              .url,
                        ),
                        ServiceProvideComponent(
                          heading: productListingModel!
                              .product.subscriptionContent!.benefitsHeading,
                          serviceList:
                              productListingModel!.product.benefits.data,
                        ),
                        const SizedBox(height: Dimension.d4),
                        PlanPricingDetailsComponent(
                          planName: productListingModel!
                              .product.subscriptionContent!.mainHeading,
                          pricingDetailsList: services.getPlansforNonCouple(
                            productListingModel!.product.prices,
                          ),
                          onSelect: store.updatePlan,
                        ),
                        const SizedBox(height: Dimension.d4),
                        CustomButton(
                          ontap: () {
                            final userStore = GetIt.I<UserDetailStore>();
                            if (store.planDetails != null) {
                              final service = GetIt.I<ProductListingServices>();
                              service.createSubscription(
                                priceId: store.planDetails!.id,
                                startDate: '2024-05-03',
                                expireDate: '2024-09-03',
                                productId: int.parse(id),
                                familyMemberIds: [
                                  userStore.userDetails!.id,
                                ],
                              ).then(
                                (result) {
                                  store.isLoading = true;
                                  result.fold(
                                    (failure) {
                                      store.isLoading = false;
                                      print(failure);
                                      return const Failure.someThingWentWrong();
                                    },
                                    (right) {
                                      store.isLoading = false;
                                      context.pushNamed(
                                        RoutesConstants
                                            .subscriptionDetailsScreen,
                                        pathParameters: {
                                          'price':
                                              '${store.planDetails!.unitAmount}',
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            }
                            print(store.planDetails);
                          },
                          title: isUpgradable ? 'Upgrade care' : 'Book Care',
                          showIcon: false,
                          iconPath: AppIcons.add,
                          size: ButtonSize.normal,
                          type: store.planDetails != null
                              ? ButtonType.primary
                              : ButtonType.disable,
                          expanded: true,
                          iconColor: AppColors.white,
                        ),
                        if (productListingModel!
                            .product.subscriptionContent!.showCouplePlans)
                          ExploreNowComponent(
                            isUpgradable: isUpgradable,
                            pageTitle: pageTitle,
                            btnLabel: productListingModel!.product
                                .subscriptionContent!.exploreNowCtaLabel,
                            planHeading: productListingModel!
                                .product
                                .subscriptionContent!
                                .exploreCouplePlansHeading!,
                            imgPath: productListingModel!
                                .product.icon.data.attributes.url,
                            backgroundColor: productListingModel!
                                .product.metadata
                                .firstWhere(
                                  (element) =>
                                      element.key == 'background_color_code',
                                  orElse: () => const Metadatum(
                                    id: 1,
                                    key: 'background_color_code',
                                    value: 'FFFDFDFD',
                                  ),
                                )
                                .value,
                            iconColorCode: productListingModel!.product.metadata
                                .firstWhere(
                                  (element) => element.key == 'icon_color_code',
                                  orElse: () => const Metadatum(
                                    id: 1,
                                    key: 'icon_color_code',
                                    value: 'FFFDFDFD',
                                  ),
                                )
                                .value,
                            plansList: services.getPlansforCouple(
                              productListingModel!.product.prices,
                            ),
                          ),
                        FAQComponent(
                          heading: productListingModel!
                              .product.subscriptionContent!.faqHeading,
                          faqList: productListingModel!
                                  .product.subscriptionContent!.faq ??
                              [],
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
