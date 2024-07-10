// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/assigning_component.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/model/payment_status_model.dart';
import 'package:silver_genie/feature/book_services/screens/service_booking_payment_detail_screen.dart';
import 'package:silver_genie/feature/genie/services/product_listing_services.dart';

// Main screen for displaying service booking details
class ServiceBookingDetailsScreen extends StatelessWidget {
  final String serviceId;

  ServiceBookingDetailsScreen({
    required this.serviceId,
    Key? key,
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
            future: service.getPaymentStatus(id: serviceId),
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: LoadingWidget(showShadow: false),
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

              late final ServicePaymentStatusModel servicePaymentStatusModel;
              try {
                servicePaymentStatusModel = snapShot.data!.getOrElse(
                  (l) => throw 'Error',
                );
              } catch (e) {
                return const ErrorStateComponent(
                    errorType: ErrorType.somethinWentWrong);
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimension.d4),
                    Text(
                      servicePaymentStatusModel.product.name,
                      style: AppTextStyle.bodyXLMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Service type: ${servicePaymentStatusModel.product.category} ${servicePaymentStatusModel.product.type}',
                      style: AppTextStyle.bodyLargeMedium
                          .copyWith(color: AppColors.grayscale600),
                    ),
                    const SizedBox(height: Dimension.d2),
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
                                _getStatusIcon(
                                    servicePaymentStatusModel.paymentStatus,
                                    servicePaymentStatusModel.status),
                                size: _getStatusIconSize(
                                    servicePaymentStatusModel.paymentStatus),
                                color: _getStatusIconColor(
                                    servicePaymentStatusModel.paymentStatus,
                                    servicePaymentStatusModel.status),
                              ),
                              const SizedBox(width: Dimension.d2),
                              Text(
                                _getStatusText(
                                    servicePaymentStatusModel.paymentStatus,
                                    servicePaymentStatusModel.status),
                                style: AppTextStyle.bodyMediumBold.copyWith(
                                  color: _getStatusTextColor(
                                      servicePaymentStatusModel.paymentStatus,
                                      servicePaymentStatusModel.status),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Divider(color: AppColors.grayscale300),
                    Text(
                      'Details',
                      style: AppTextStyle.bodyXLMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 2.6,
                      ),
                    ),
                    const SizedBox(height: Dimension.d2),
                    AssigningComponent(
                      name: 'Service opted for',
                      initializeElement:
                          ' ${servicePaymentStatusModel.requestedFor.first.firstName} ${servicePaymentStatusModel.requestedFor.first.lastName}',
                    ),
                    const SizedBox(height: Dimension.d2),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          !servicePaymentStatusModel.metadata[index].private
                              ? AssigningComponent(
                                  name: servicePaymentStatusModel
                                      .metadata[index].key,
                                  initializeElement: servicePaymentStatusModel
                                      .metadata[index].value,
                                )
                              : const SizedBox(),
                      separatorBuilder: (context, index) =>
                          !servicePaymentStatusModel.metadata[index].private
                              ? const SizedBox(height: Dimension.d3)
                              : const SizedBox(),
                      itemCount: servicePaymentStatusModel.metadata.length,
                    ),
                    const SizedBox(height: Dimension.d4),
                    const Divider(color: AppColors.line),
                    Text(
                      'Order Info',
                      style: AppTextStyle.bodyXLMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 2.4,
                      ),
                    ),
                    ElementSpaceBetween(
                      title: servicePaymentStatusModel
                          .priceDetails.products.first.displayName,
                      description:
                          '₹ ${formatNumberWithCommas(servicePaymentStatusModel.priceDetails.products.first.price.toInt())}',
                    ),
                    const Divider(color: AppColors.line),
                    const SizedBox(height: Dimension.d2),
                    ElementSpaceBetween(
                      title: _getPaymentTextTitle(
                          servicePaymentStatusModel.paymentStatus,
                          servicePaymentStatusModel.status),
                      description:
                          '₹ ${formatNumberWithCommas(servicePaymentStatusModel.priceDetails.products.first.price.toInt())}',
                      isTitleBold: true,
                    ),
                    const SizedBox(height: Dimension.d15),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(String paymentStatus, String status) {
    if (paymentStatus == 'due' || paymentStatus == 'expired') {
      return AppIcons.warning;
    }
    if (status == 'requested' || status == 'processing') {
      return AppIcons.medical_services;
    }
    return AppIcons.check;
  }
}

double _getStatusIconSize(String paymentStatus) {
  return paymentStatus == 'due' || paymentStatus == 'expired' ? 16 : 14;
}

Color _getStatusIconColor(String paymentStatus, String status) {
  if (paymentStatus == 'due' || paymentStatus == 'expired') {
    return AppColors.warning2;
  }
  return AppColors.grayscale800;
}

String _getStatusText(String paymentStatus, String status) {
  if (paymentStatus == 'due') {
    return 'Payment pending';
  }
  if (paymentStatus == 'expired') {
    return 'Payment failure';
  }
  if (status == 'requested' || status == 'processing') {
    return 'Service in progress';
  }
  if (status == 'active' || status == 'processed') {
    return 'Service scheduled';
  }
  if (status == 'rejected') {
    return 'Service rejected';
  }
  if (status == 'completed') {
    return 'Service completed';
  }
  return 'Unknown';
}

Color _getStatusTextColor(String paymentStatus, String status) {
  if (paymentStatus == 'due' || paymentStatus == 'expired') {
    return AppColors.warning2;
  }
  return AppColors.grayscale800;
}

String _getPaymentTextTitle(String paymentStatus, String status) {
  if (paymentStatus == 'due' || paymentStatus == 'expired') {
    return 'Total to pay';
  }
  return 'Total paid';
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
        const SizedBox(width: Dimension.d2),
        Text(
          description,
          style: style,
        ),
      ],
    );
  }
}
