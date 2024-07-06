// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/payment/payment_services.dart';
import 'package:silver_genie/core/widgets/assigning_component.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/model/payment_status_model.dart';
import 'package:silver_genie/feature/book_services/screens/booking_payment_detail_screen.dart';
import 'package:silver_genie/feature/book_services/screens/payment_screen.dart';
import 'package:silver_genie/feature/genie/services/product_listing_services.dart';

class PaymentStatusTrackingPage extends StatelessWidget {
  final String id;
  PaymentStatusTrackingPage({
    Key? key,
    required this.id,
  }) : super(key: key);
  final service = GetIt.I<ProductListingServices>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PageAppbar(title: 'Booking Details'),
        backgroundColor: AppColors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
          child: FutureBuilder(
            future: service.getPaymentStatus(id: id),
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: LoadingWidget(
                    showShadow: false,
                  ),
                );
              }
              if (snapShot.hasError) {
                return const ErrorStateComponent(
                    errorType: ErrorType.somethinWentWrong);
              }
              if (!snapShot.hasData) {
                return const SizedBox();
              }
              if (snapShot.data!.isLeft()) {
                return const ErrorStateComponent(
                    errorType: ErrorType.somethinWentWrong);
              }
              late final PaymentStatusModel paymentStatusModel;
              try {
                paymentStatusModel = snapShot.data!.getOrElse(
                  (l) => throw 'Error',
                );
              } catch (e) {
                return const ErrorStateComponent(
                    errorType: ErrorType.somethinWentWrong);
              }
              final paymentStatus = getPaymentStatus(
                  paymentStatus: paymentStatusModel.paymentStatus,
                  status: paymentStatusModel.status);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: Dimension.d4,
                    ),
                    Text(
                      paymentStatusModel
                          .priceDetails.products.first.productName,
                      style: AppTextStyle.bodyXLMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Service type: ${paymentStatusModel.product.category} ${paymentStatusModel.product.type}',
                      style: AppTextStyle.bodyLargeMedium
                          .copyWith(color: AppColors.grayscale600),
                    ),
                    const SizedBox(
                      height: Dimension.d2,
                    ),
                    Container(
                      height: 58,
                      width: double.infinity,
                      margin:
                          const EdgeInsets.symmetric(vertical: Dimension.d2),
                      padding:
                          const EdgeInsets.symmetric(horizontal: Dimension.d2),
                      decoration: BoxDecoration(
                        color: AppColors.grayscale200,
                        borderRadius: BorderRadius.circular(Dimension.d2),
                        border: Border.all(color: AppColors.grayscale300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Booking Status',
                              style: AppTextStyle.bodyMediumMedium),
                          Row(
                            children: [
                              Icon(
                                paymentStatus == PaymentStatus.pending
                                    ? Icons.error_outline_outlined
                                    : AppIcons.check,
                                size: paymentStatus == PaymentStatus.pending
                                    ? 16
                                    : 14,
                                color: paymentStatus == PaymentStatus.pending
                                    ? AppColors.warning2
                                    : AppColors.grayscale800,
                              ),
                              const SizedBox(
                                width: Dimension.d2,
                              ),
                              Text(
                                paymentStatus == PaymentStatus.pending
                                    ? 'Payment Pending'
                                    : 'Payment Completed',
                                style: AppTextStyle.bodyMediumBold.copyWith(
                                    color:
                                        paymentStatus == PaymentStatus.pending
                                            ? AppColors.warning2
                                            : AppColors.grayscale800),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      color: AppColors.grayscale300,
                    ),
                    Text(
                      'Details',
                      style: AppTextStyle.bodyXLMedium
                          .copyWith(fontWeight: FontWeight.w500, height: 2.6),
                    ),
                    const SizedBox(
                      height: Dimension.d2,
                    ),
                    AssigningComponent(
                      name: 'Service opted for',
                      initializeElement:
                          ' ${paymentStatusModel.requestedFor.first.firstName} ${paymentStatusModel.requestedFor.first.lastName}',
                    ),
                    const SizedBox(
                      height: Dimension.d2,
                    ),
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => !paymentStatusModel
                                .metadata[index].private
                            ? AssigningComponent(
                                name: paymentStatusModel.metadata[index].key,
                                initializeElement:
                                    paymentStatusModel.metadata[index].value,
                              )
                            : const SizedBox(),
                        separatorBuilder: (context, index) =>
                            !paymentStatusModel.metadata[index].private
                                ? const SizedBox(
                                    height: Dimension.d3,
                                  )
                                : const SizedBox(),
                        itemCount: paymentStatusModel.metadata.length),
                    const SizedBox(
                      height: Dimension.d4,
                    ),
                    const Divider(
                      color: AppColors.line,
                    ),
                    Text('Payment breakdown',
                        style: AppTextStyle.bodyLargeSemiBold.copyWith(
                            fontSize: 18,
                            color: AppColors.grayscale900,
                            height: 2.6)),
                    ElementSpaceBetween(
                      title: paymentStatusModel
                          .priceDetails.products.first.displayName,
                      description:
                          '₹ ${formatNumberWithCommas(paymentStatusModel.priceDetails.products.first.price.toInt())}',
                    ),
                    const Divider(
                      color: AppColors.line,
                    ),
                    ElementSpaceBetween(
                      title:
                          '${paymentStatusModel.priceDetails.products.first.displayName} x ${paymentStatusModel.priceDetails.products.first.quantity} days',
                      description:
                          '₹ ${formatNumberWithCommas(paymentStatusModel.amount.toInt())}',
                    ),
                    const Divider(
                      color: AppColors.line,
                    ),
                    const SizedBox(
                      height: Dimension.d2,
                    ),
                    ElementSpaceBetween(
                      title: 'Total to pay',
                      description:
                          '₹ ${formatNumberWithCommas(paymentStatusModel.amount.toInt())}',
                      isTitleBold: true,
                    ),
                    const SizedBox(
                      height: Dimension.d15,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ElementSpaceBetween extends StatelessWidget {
  ElementSpaceBetween({
    required this.title,
    required this.description,
    this.isTitleBold = false,
  });
  final String title;
  final String description;
  bool isTitleBold;

  final style = AppTextStyle.bodyLargeMedium.copyWith(height: 2);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: isTitleBold
                ? AppTextStyle.bodyXLMedium
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 18)
                : style,
          ),
        ),
        const SizedBox(
          width: Dimension.d2,
        ),
        Text(
          description,
          style: style,
        ),
      ],
    );
  }
}
