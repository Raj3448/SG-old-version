// ignore_for_file: inference_failure_on_function_invocation, lines_longer_than_80_chars, must_be_immutable, inference_failure_on_instance_creation, always_put_required_named_parameters_first, library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
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

class GeniePage extends StatefulWidget {
  const GeniePage({
    super.key,
    required this.pageTitle,
    required this.id,
    required this.isUpgradable,
  });

  final String pageTitle;
  final String id;
  final bool isUpgradable;

  @override
  _GeniePageState createState() => _GeniePageState();
}

class _GeniePageState extends State<GeniePage> {
  final services = GetIt.I<ProductListingServices>();
  final store = GetIt.I<ProductListingStore>();
  final userStore = GetIt.I<UserDetailStore>();

  late ProductListingModel? productListingModel;

  @override
  void initState() {
    super.initState();
    store.getProductById(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PageAppbar(title: widget.pageTitle),
        backgroundColor: AppColors.white,
        body: Observer(
          builder: (context) {
            final productListingModel = store.subscriptionModel;
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
                  child: SingleChildScrollView(
                    child: store.subscriptionLoading
                        ? const LoadingWidget(showShadow: false)
                        : productListingModel == null ||
                                productListingModel
                                        .product.subscriptionContent ==
                                    null
                            ? const ErrorStateComponent(
                                errorType: ErrorType.somethinWentWrong,
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GenieOverviewComponent(
                                    title: productListingModel.product
                                        .subscriptionContent!.mainHeading,
                                    headline: productListingModel
                                        .product
                                        .subscriptionContent!
                                        .headingDescription,
                                    defination: productListingModel
                                        .product
                                        .subscriptionContent!
                                        .subHeading1Description,
                                    subHeading: productListingModel.product
                                        .subscriptionContent!.subHeading1,
                                    imageUrl: productListingModel
                                        .product
                                        .subscriptionContent!
                                        .productImage!
                                        .data
                                        .attributes
                                        .url,
                                  ),
                                  ServiceProvideComponent(
                                    heading: productListingModel.product
                                        .subscriptionContent!.benefitsHeading,
                                    serviceList: productListingModel
                                        .product.benefits!.data,
                                  ),
                                  const SizedBox(height: Dimension.d4),
                                  PlanPricingDetailsComponent(
                                    planName: productListingModel.product
                                        .subscriptionContent!.mainHeading,
                                    pricingDetailsList:
                                        services.getPlansforNonCouple(
                                      productListingModel.product.prices,
                                    ),
                                    onSelect: store.updatePlan,
                                  ),
                                  const SizedBox(height: Dimension.d4),
                                  CustomButton(
                                    ontap: () {
                                      if (store.planDetails != null) {
                                        setState(() {
                                          store.isLoading = true;
                                        });
                                        store.createSubscription(
                                          priceId: store.planDetails!.id,
                                          productId: int.parse(widget.id),
                                          familyMemberIds: [
                                            userStore.userDetails!.id,
                                          ],
                                        ).then((result) {
                                          setState(() {
                                            store.isLoading = false;
                                          });
                                          result.fold(
                                            (failure) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Something went wrong!',
                                                  ),
                                                ),
                                              );
                                            },
                                            (right) {
                                              context.pushNamed(
                                                RoutesConstants
                                                    .subscriptionDetailsScreen,
                                                pathParameters: {
                                                  'price':
                                                      '${store.planDetails!.unitAmount}',
                                                  'subscriptionData': json
                                                      .encode(right.toJson()),
                                                  'isCouple': 'false',
                                                },
                                              );
                                            },
                                          );
                                        });
                                      }
                                    },
                                    title: widget.isUpgradable
                                        ? 'Upgrade care'
                                        : 'Book Care',
                                    showIcon: false,
                                    iconPath: AppIcons.add,
                                    size: ButtonSize.normal,
                                    type: store.planDetails != null
                                        ? ButtonType.primary
                                        : ButtonType.disable,
                                    expanded: true,
                                    iconColor: AppColors.white,
                                  ),
                                  if (productListingModel.product
                                      .subscriptionContent!.showCouplePlans)
                                    ExploreNowComponent(
                                      id: widget.id,
                                      isUpgradable: widget.isUpgradable,
                                      pageTitle: widget.pageTitle,
                                      btnLabel: productListingModel
                                          .product
                                          .subscriptionContent!
                                          .exploreNowCtaLabel,
                                      planHeading: productListingModel
                                          .product
                                          .subscriptionContent!
                                          .exploreCouplePlansHeading!,
                                      imgPath: productListingModel
                                          .product.icon!.data.attributes.url,
                                      backgroundColor:
                                          productListingModel.product.metadata!
                                              .firstWhere(
                                                (element) =>
                                                    element.key ==
                                                    'background_color_code',
                                                orElse: () => const Metadatum(
                                                  id: 1,
                                                  key: 'background_color_code',
                                                  value: 'FFFDFDFD',
                                                ),
                                              )
                                              .value,
                                      iconColorCode:
                                          productListingModel.product.metadata!
                                              .firstWhere(
                                                (element) =>
                                                    element.key ==
                                                    'icon_color_code',
                                                orElse: () => const Metadatum(
                                                  id: 1,
                                                  key: 'icon_color_code',
                                                  value: 'FFFDFDFD',
                                                ),
                                              )
                                              .value,
                                      plansList: services.getPlansforCouple(
                                        productListingModel.product.prices,
                                      ),
                                    ),
                                  FAQComponent(
                                    heading: productListingModel.product
                                        .subscriptionContent!.faqHeading,
                                    faqList: productListingModel
                                            .product.subscriptionContent!.faq ??
                                        [],
                                  ),
                                ],
                              ),
                  ),
                ),
                if (store.isLoading) const LoadingWidget(),
              ],
            );
          },
        ),
      ),
    );
  }
}
