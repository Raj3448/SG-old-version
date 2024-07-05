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
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/model/payment_status_model.dart';
import 'package:silver_genie/feature/book_services/widgets/booking_status.dart';
import 'package:silver_genie/feature/bookings/booking_sevice_status_page.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';

import 'booking_payment_detail_screen.dart';

class PaymentScreen extends StatefulWidget {
  PaymentStatusModel? paymentStatusModel;
  final PriceDetails? priceDetails;
  String id;

  PaymentScreen(
      {required this.paymentStatusModel,
      required this.priceDetails,
      required this.id,
      Key? key})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final PaymentStatus paymentStatus;
  final store = GetIt.I<ProductListingStore>();
  Timer? _timer;
  @override
  void initState() {
    paymentStatus = widget.paymentStatusModel == null
        ? PaymentStatus.failure
        : _getPaymentStatus();
    if (paymentStatus == PaymentStatus.pending) {
      _startPaymentStatusPolling();
    }
    reaction((_) => store.paymentStatusModel, (paymentStatusModel) {
      if (paymentStatusModel != null) {
        setState(() {
          widget.paymentStatusModel = paymentStatusModel;
        });
        _stopPaymentStatusPolling();
      }
      store.paymentStatusModel = null;
    });
    super.initState();
  }

  void _startPaymentStatusPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      store.getPaymentStatus(id: widget.id);
    });
  }

  void _stopPaymentStatusPolling() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _stopPaymentStatusPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: const PageAppbar(title: 'Book Service'),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FixedButton(
            ontap: () {
              if (widget.paymentStatusModel != null) {
                GetIt.I<ProductListingStore>().servicePaymentInfoGotSuccess =
                    null;
                context
                  ..pop()
                  ..pop();
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
                    paymentStatus == PaymentStatus.success
                        ? 'assets/icon/success.svg'
                        : paymentStatus == PaymentStatus.pending
                            ? 'assets/icon/pending.svg'
                            : 'assets/icon/failure.svg',
                    color: paymentStatus == PaymentStatus.success
                        ? Colors.green
                        : null,
                  ),
                  Text(
                    _getPaymentStatusMessage(paymentStatus),
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
                            color: AppColors.grayscale900, height: 2.6),
                      ),
                      const Divider(
                        color: AppColors.grayscale300,
                      ),
                      ElementSpaceBetween(
                        title: paymentStatus == PaymentStatus.failure
                            ? widget.priceDetails!.products.first.displayName
                            : widget.paymentStatusModel!.priceDetails.products
                                .first.displayName,
                        description: paymentStatus == PaymentStatus.failure
                            ? '₹ ${formatNumberWithCommas(widget.priceDetails!.products.first.price.toInt())}'
                            : '₹ ${formatNumberWithCommas(widget.paymentStatusModel!.priceDetails.products.first.price.toInt())}',
                      ),
                      const Divider(
                        color: AppColors.grayscale300,
                      ),
                      ElementSpaceBetween(
                        title: 'Total to pay',
                        description: paymentStatus == PaymentStatus.failure
                            ? '₹ ${formatNumberWithCommas(widget.priceDetails!.totalAmount.toInt())}'
                            : '₹ ${formatNumberWithCommas(widget.paymentStatusModel!.amount.toInt())}',
                        isTitleBold: true,
                      ),
                      const Divider(
                        color: AppColors.grayscale300,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: Dimension.d20,
                  )
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

  PaymentStatus _getPaymentStatus() {
    if (widget.paymentStatusModel!.paymentStatus == 'due' &&
        widget.paymentStatusModel!.status == 'requested') {
      return PaymentStatus.pending;
    }
    if (widget.paymentStatusModel!.paymentStatus == 'paid' &&
        widget.paymentStatusModel!.status == 'processing') {
      return PaymentStatus.success;
    } else {
      return PaymentStatus.failure;
    }
  }
}
