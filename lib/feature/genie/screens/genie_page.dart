import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/genie_overview.dart';
import 'package:silver_genie/core/widgets/info_dialog.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/dummy_variables.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/services/product_listing_services.dart';

class GeniePage extends StatelessWidget {
  GeniePage({
    required this.pageTitle,
    required this.id,
    required this.isUpgradble,
    super.key,
  });

  final String pageTitle;
  final String id;
  final bool isUpgradble;
  final services = GetIt.I<ProductLisitingServices>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Observer(
        builder: (context) {
          return Scaffold(
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
                      errorType: ErrorType.somethinWentWrong);
                }
                ProductListingModel? productListingModel;
                snapshot.data!.fold((l) {
                  return const ErrorStateComponent(
                      errorType: ErrorType.somethinWentWrong);
                }, (r) {
                  productListingModel = r;
                });

                if (productListingModel == null ||
                    productListingModel!.product.subscriptionContent == null) {
                  return const ErrorStateComponent(
                      errorType: ErrorType.somethinWentWrong);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
                  child: SingleChildScrollView(
                    child: Column(
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
                              .productImage
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
                          pricingDetailsList:
                              productListingModel!.product.prices,
                        ),
                        CustomButton(
                          ontap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const InfoDialog(
                                  showIcon: true,
                                  title: 'Your request has been received',
                                  desc:
                                      'Thank you for your interest. The SG team will be in touch with you shortly.',
                                  btnTitle: 'Back to Home',
                                  showBtnIcon: false,
                                  btnIconPath: AppIcons.arrow_back_ios,
                                );
                              },
                            );
                          },
                          title: isUpgradble? 'Upgrade care' : 'Book Care',
                          showIcon: false,
                          iconPath: AppIcons.add,
                          size: ButtonSize.normal,
                          type: ButtonType.primary,
                          expanded: true,
                          iconColor: AppColors.white,
                        ),
                        if (productListingModel!
                            .product.subscriptionContent!.showCouplePlans)
                          ExploreNowComponent(
                            pageTitle: pageTitle,
                            btnLabel: productListingModel!.product
                                .subscriptionContent!.exploreNowCtaLabel,
                            planHeading: productListingModel!.product
                                .subscriptionContent!.exploreCouplePlansHeading,
                            imgPath: productListingModel!
                                .product.icon.data.attributes.url,
                            colorCode: productListingModel!
                                .product.metadata.first.value,
                          ),
                        FAQComponent(
                          questionsAndContentList: questionAndAnswerList,
                          heading: productListingModel!
                              .product.subscriptionContent!.faqHeading,
                          faqList: productListingModel!
                              .product.subscriptionContent!.faq,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
