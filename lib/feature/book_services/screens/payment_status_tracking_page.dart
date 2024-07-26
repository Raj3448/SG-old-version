// ignore_for_file: public_member_api_docs, sort_constructors_first, lines_longer_than_80_chars
// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/payment/payment_services.dart';
import 'package:silver_genie/core/routes/routes.dart';
import 'package:silver_genie/core/utils/download_invoice.dart';
import 'package:silver_genie/core/utils/launch_dialer.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/model/payment_status_model.dart';
import 'package:silver_genie/feature/book_services/screens/service_booking_payment_detail_screen.dart';
import 'package:silver_genie/feature/book_services/screens/service_payment_screen.dart';
import 'package:silver_genie/feature/bookings/store/booking_service_store.dart';
import 'package:silver_genie/feature/genie/services/product_listing_services.dart';

class ServicePaymentStatusTrackingPage extends StatefulWidget {
  final String id;
  const ServicePaymentStatusTrackingPage({
    required this.id,
    super.key,
  });

  @override
  State<ServicePaymentStatusTrackingPage> createState() =>
      _ServicePaymentStatusTrackingPageState();
}

class _ServicePaymentStatusTrackingPageState
    extends State<ServicePaymentStatusTrackingPage> {
  final service = GetIt.I<ProductListingServices>();

  final bookingServiceStore = GetIt.I<BookingServiceStore>();

  bool isTimerTrigger = false;

  late Timer _timer;
  ServicePaymentStatusModel? servicePaymentStatusModel;

  @override
  void dispose() {
    if (isTimerTrigger) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Stack(
          children: [
            Scaffold(
              appBar: const PageAppbar(title: 'Booking Details'),
              backgroundColor: AppColors.white,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
                child: servicePaymentStatusModel == null
                    ? FutureBuilder(
                        future: service.getPaymentStatus(id: widget.id),
                        builder: (context, snapShot) {
                          if (snapShot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: LoadingWidget(
                                showShadow: false,
                              ),
                            );
                          }
                          if (snapShot.hasError) {
                            return const ErrorStateComponent(
                              errorType: ErrorType.somethinWentWrong,
                            );
                          }
                          if (!snapShot.hasData) {
                            return const SizedBox();
                          }
                          if (snapShot.data!.isLeft()) {
                            return const ErrorStateComponent(
                              errorType: ErrorType.somethinWentWrong,
                            );
                          }
                          try {
                            servicePaymentStatusModel =
                                snapShot.data!.getOrElse(
                              (l) => throw 'Error',
                            );
                          } catch (e) {
                            return const ErrorStateComponent(
                              errorType: ErrorType.somethinWentWrong,
                            );
                          }
                          final paymentStatus = getPaymentStatus(
                            paymentStatus:
                                servicePaymentStatusModel?.paymentStatus ?? '',
                            status: servicePaymentStatusModel?.status ?? '',
                          );
                          return buildDetail(context, paymentStatus);
                        },
                      )
                    : buildDetail(
                        context,
                        getPaymentStatus(
                          paymentStatus:
                              servicePaymentStatusModel!.paymentStatus,
                          status: servicePaymentStatusModel!.status,
                        ),
                      ),
              ),
            ),
            if (bookingServiceStore.isFileInDownloadProcess)
              const Material(
                color: Colors.transparent,
                child: LoadingWidget(),
              ),
          ],
        );
      },
    );
  }

  Widget buildDetail(BuildContext context, PaymentStatus paymentStatus) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Dimension.d4,
          ),
          Text(
            servicePaymentStatusModel!.priceDetails.products.first.productName,
            style: AppTextStyle.bodyXLMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Service type: ${servicePaymentStatusModel!.product.category} ${servicePaymentStatusModel!.product.type}',
            style: AppTextStyle.bodyLargeMedium
                .copyWith(color: AppColors.grayscale600),
          ),
          const SizedBox(
            height: Dimension.d2,
          ),
          Container(
            height: 58,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: Dimension.d2),
            padding: const EdgeInsets.symmetric(horizontal: Dimension.d2),
            decoration: BoxDecoration(
              color: AppColors.grayscale200,
              borderRadius: BorderRadius.circular(Dimension.d2),
              border: Border.all(color: AppColors.grayscale300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Booking Status',
                  style: AppTextStyle.bodyMediumMedium,
                ),
                Row(
                  children: [
                    Icon(
                      paymentStatus == PaymentStatus.pending
                          ? Icons.error_outline_outlined
                          : AppIcons.check,
                      size: _getStatusIconSize(
                        servicePaymentStatusModel!.paymentStatus,
                      ),
                      color: _getStatusIconColor(
                        servicePaymentStatusModel!.paymentStatus,
                        servicePaymentStatusModel!.status,
                      ),
                    ),
                    const SizedBox(
                      width: Dimension.d2,
                    ),
                    Text(
                      _getStatusText(
                        servicePaymentStatusModel!.paymentStatus,
                        servicePaymentStatusModel!.status,
                      ),
                      style: AppTextStyle.bodyMediumBold.copyWith(
                        color: _getStatusTextColor(
                          servicePaymentStatusModel!.paymentStatus,
                          servicePaymentStatusModel!.status,
                        ),
                      ),
                    ),
                  ],
                ),
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
          ExpandedAnalogComponent(
            label: 'Service opted for',
            value:
                ' ${servicePaymentStatusModel!.requestedFor.first.firstName} ${servicePaymentStatusModel!.requestedFor.first.lastName}',
          ),
          const SizedBox(
            height: Dimension.d2,
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                !servicePaymentStatusModel!.metadata[index].private
                    ? ExpandedAnalogComponent(
                        label: servicePaymentStatusModel!.metadata[index].key,
                        value: servicePaymentStatusModel!.metadata[index].value,
                      )
                    : const SizedBox(),
            separatorBuilder: (context, index) =>
                !servicePaymentStatusModel!.metadata[index].private
                    ? const SizedBox(
                        height: Dimension.d3,
                      )
                    : const SizedBox(),
            itemCount: servicePaymentStatusModel!.metadata.length,
          ),
          const SizedBox(
            height: Dimension.d4,
          ),
          const Divider(
            color: AppColors.line,
          ),
          Text(
            'Payment breakdown',
            style: AppTextStyle.bodyLargeSemiBold.copyWith(
              fontSize: 18,
              color: AppColors.grayscale900,
              height: 2.6,
            ),
          ),
          ElementSpaceBetween(
            title: servicePaymentStatusModel!
                .priceDetails.products.first.displayName,
            description:
                '₹ ${formatNumberWithCommas(servicePaymentStatusModel!.priceDetails.products.first.price)}',
          ),
          const Divider(
            color: AppColors.line,
          ),
          ElementSpaceBetween(
            title:
                '${servicePaymentStatusModel!.priceDetails.products.first.displayName}  x  ${servicePaymentStatusModel!.priceDetails.products.first.quantity}',
            description:
                '₹ ${formatNumberWithCommas(servicePaymentStatusModel!.amount)}',
          ),
          const Divider(
            color: AppColors.line,
          ),
          const SizedBox(
            height: Dimension.d2,
          ),
          ElementSpaceBetween(
            title: _getPaymentTextTitle(
              servicePaymentStatusModel!.paymentStatus,
              servicePaymentStatusModel!.status,
            ),
            description:
                '₹ ${formatNumberWithCommas(servicePaymentStatusModel!.amount)}',
            isTitleBold: true,
          ),
          const SizedBox(
            height: Dimension.d5,
          ),
          if (servicePaymentStatusModel!.paymentTansactions.isNotEmpty &&
              servicePaymentStatusModel!.paymentTansactions.first.invoice !=
                  null) ...[
            CustomButton(
              ontap: () {
                startDownloadInvoice(
                  invoice: servicePaymentStatusModel!
                      .paymentTansactions.first.invoice!,
                  isTimerTrigger: (p0) {
                    isTimerTrigger = p0;
                  },
                  getTimer: (p0) {
                    _timer = p0;
                  },
                  fileDownloading: (loading) {
                    bookingServiceStore.isFileInDownloadProcess = loading;
                  },
                  scaffoldMessenger: ScaffoldMessenger.of(context),
                );
              },
              title: 'Download invoice',
              showIcon: true,
              iconPath: Icons.file_download_outlined,
              size: ButtonSize.normal,
              type: ButtonType.secondary,
              expanded: true,
              iconColor: AppColors.primary,
            ),
            const SizedBox(
              height: Dimension.d4,
            ),
          ],
          CustomButton(
            ontap: () async {
              await launchDialer(
                homeStore.getMasterDataModel?.masterData.contactUs
                        .contactNumber ??
                    '',
              );
            },
            title: 'Help-Contact customer care',
            showIcon: true,
            iconPath: AppIcons.phone,
            size: ButtonSize.normal,
            type: ButtonType.secondary,
            expanded: true,
            iconColor: AppColors.primary,
          ),
          const SizedBox(
            height: Dimension.d15,
          ),
        ],
      ),
    );
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

Color _getStatusTextColor(String paymentStatus, String status) {
  if (paymentStatus == 'due' || paymentStatus == 'expired') {
    return AppColors.warning2;
  }
  return AppColors.grayscale800;
}

String _getStatusText(String paymentStatus, String status) {
  if (paymentStatus == 'due') {
    return 'Payment processing';
  }
  if (paymentStatus == 'expired') {
    return 'Payment failure';
  }
  if (status == 'requested' || status == 'processing') {
    return 'Payment Completed';
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

class ElementSpaceBetween extends StatelessWidget {
  ElementSpaceBetween({
    required this.title,
    required this.description,
    this.isTitleBold = false,
    super.key,
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

String _getPaymentTextTitle(String paymentStatus, String status) {
  if (paymentStatus == 'due' || paymentStatus == 'expired') {
    return 'Total to pay';
  }
  return 'Total paid';
}
