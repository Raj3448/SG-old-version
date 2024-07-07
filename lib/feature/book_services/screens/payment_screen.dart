// ignore_for_file: deprecated_member_use, lines_longer_than_80_chars, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/payment/payment_services.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/model/payment_status_model.dart';
import 'package:silver_genie/feature/book_services/screens/booking_payment_detail_screen.dart';
import 'package:silver_genie/feature/book_services/widgets/booking_status.dart';
import 'package:silver_genie/feature/bookings/booking_details_screen.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({
    required this.paymentStatusModel,
    required this.priceDetails,
    required this.id,
    super.key,
  });
  PaymentStatusModel? paymentStatusModel;
  final PriceDetails? priceDetails;
  final String id;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final store = GetIt.I<ProductListingStore>();
  Timer? _timer;
  late ReactionDisposer _reactionDisposer;

  @override
  void initState() {
    store.servicePaymentStatus = widget.paymentStatusModel == null
        ? PaymentStatus.failure
        : getPaymentStatus(
            paymentStatus: widget.paymentStatusModel!.paymentStatus,
            status: widget.paymentStatusModel!.status,
          );
    if (store.servicePaymentStatus == PaymentStatus.pending) {
      _startPaymentStatusPolling();
    }
    _reactionDisposer =
        reaction((_) => store.paymentStatusModel, (paymentStatusModel) {
      if (paymentStatusModel != null) {
        widget.paymentStatusModel = paymentStatusModel;
        store.servicePaymentStatus = PaymentStatus.success;
        widget.paymentStatusModel = paymentStatusModel;
        store.servicePaymentStatus = PaymentStatus.success;
        _stopPaymentStatusPolling();
      }
      store.paymentStatusModel = null;
    });
    super.initState();
  }

  void _startPaymentStatusPolling() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      store.getPaymentStatus(id: widget.id);
    });
  }

  void _stopPaymentStatusPolling() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _stopPaymentStatusPolling();
    _reactionDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: PageAppbar(
            title: 'Book Service',
            onTap: store.servicePaymentStatus == PaymentStatus.failure
                ? () {
                    context.pop();
                  }
                : () {
                    context
                      ..pop()
                      ..pop();
                  },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FixedButton(
            ontap: () {
              if (widget.paymentStatusModel != null) {
                GetIt.I<ProductListingStore>().servicePaymentInfoGotSuccess =
                    null;
                context.pushNamed(
                  RoutesConstants.paymentStatusTrackingPage,
                  pathParameters: {'id': widget.id},
                );
              } else {
                context.pop();
              }
            },
            btnTitle: widget.paymentStatusModel != null
                ? 'Track Booking status'
                : 'Retry Payment',
            showIcon: false,
            iconPath: AppIcons.add,
          ),
          body: Padding(
            padding: const EdgeInsets.all(Dimension.d3),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const BookingStatus(currentStep: BookingStep.bookingDetails),
                  const SizedBox(height: Dimension.d4),
                  SvgPicture.asset(
                    store.servicePaymentStatus == PaymentStatus.success
                        ? 'assets/icon/success.svg'
                        : store.servicePaymentStatus == PaymentStatus.pending
                            ? 'assets/icon/pending.svg'
                            : 'assets/icon/failure.svg',
                    color: store.servicePaymentStatus == PaymentStatus.success
                        ? Colors.green
                        : null,
                  ),
                  Text(
                    _getPaymentStatusMessage(store.servicePaymentStatus!),
                    style: AppTextStyle.bodyXLSemiBold
                        .copyWith(fontSize: 20, height: 2.8),
                  ),
                  const SizedBox(height: Dimension.d2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Info',
                        style: AppTextStyle.bodyXLSemiBold.copyWith(
                          color: AppColors.grayscale900,
                          height: 2.6,
                        ),
                      ),
                      const Divider(
                        color: AppColors.grayscale300,
                      ),
                      ElementSpaceBetween(
                        title: store.servicePaymentStatus ==
                                PaymentStatus.failure
                            ? widget.priceDetails!.products.first.displayName
                            : widget.paymentStatusModel!.priceDetails.products
                                .first.displayName,
                        description: store.servicePaymentStatus ==
                                PaymentStatus.failure
                            ? '₹ ${formatNumberWithCommas(widget.priceDetails!.products.first.price)}'
                            : '₹ ${formatNumberWithCommas(widget.paymentStatusModel!.priceDetails.products.first.price)}',
                      ),
                      const Divider(
                        color: AppColors.grayscale300,
                      ),
                      ElementSpaceBetween(
                        title: 'Total to pay',
                        description: store.servicePaymentStatus ==
                                PaymentStatus.failure
                            ? '₹ ${formatNumberWithCommas(widget.priceDetails!.totalAmount)}'
                            : '₹ ${formatNumberWithCommas(widget.paymentStatusModel!.amount)}',
                        isTitleBold: true,
                      ),
                      const Divider(
                        color: AppColors.grayscale300,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: Dimension.d20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getPaymentStatusMessage(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.success:
        return 'Payment Successful';
      case PaymentStatus.pending:
        return 'Payment Pending';
      case PaymentStatus.failure:
        return 'Payment Failure';
    }
  }
}

PaymentStatus getPaymentStatus({
  required String paymentStatus,
  required String status,
}) {
  if (paymentStatus == 'due' && status == 'requested') {
    return PaymentStatus.pending;
  }
  if (paymentStatus == 'paid') {
    return PaymentStatus.success;
  } else {
    return PaymentStatus.failure;
  }
}
