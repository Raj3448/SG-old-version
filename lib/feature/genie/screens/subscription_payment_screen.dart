// ignore_for_file: must_be_immutable, lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:silver_genie/feature/book_services/screens/booking_payment_detail_screen.dart';
import 'package:silver_genie/feature/book_services/screens/service_payment_screen.dart';
import 'package:silver_genie/feature/bookings/booking_details_screen.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  SubscriptionPaymentScreen({
    required this.subscriptionDetails,
    required this.priceId,
    required this.price,
    super.key,
  });
  SubscriptionDetails? subscriptionDetails;
  final String priceId;
  final String price;

  @override
  State<SubscriptionPaymentScreen> createState() =>
      _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  final store = GetIt.I<ProductListingStore>();
  Timer? _timer;
  late ReactionDisposer _reactionDisposer;

  @override
  void initState() {
    store.servicePaymentStatus = widget.subscriptionDetails == null
        ? PaymentStatus.failure
        : getPaymentStatus(
            paymentStatus: widget.subscriptionDetails!.paymentStatus,
            status: widget.subscriptionDetails!.status,
          );
    if (store.servicePaymentStatus == PaymentStatus.pending) {
      _startPaymentStatusPolling();
    }
    _reactionDisposer = reaction((_) => store.subscrpaymentStatusModel,
        (subscrpaymentStatusModel) {
      if (subscrpaymentStatusModel != null) {
        widget.subscriptionDetails = subscrpaymentStatusModel;
        store.servicePaymentStatus = PaymentStatus.success;
        widget.subscriptionDetails = subscrpaymentStatusModel;
        store.servicePaymentStatus = PaymentStatus.success;
        _stopPaymentStatusPolling();
      }
      store.paymentStatusModel = null;
    });
    super.initState();
  }

  void _startPaymentStatusPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      store.getSubscriptionPaymentStatus(
        id: widget.subscriptionDetails!.id.toString(),
      );
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
            title: 'Book subscription',
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
              if (widget.subscriptionDetails != null) {
                GetIt.I<ProductListingStore>().servicePaymentInfoGotSuccess =
                    null;
                context.pushNamed(
                  RoutesConstants.bookingDetailsScreen,
                  pathParameters: {
                    'id': '${widget.subscriptionDetails!.id}',
                  },
                );
              } else {
                context.pop();
              }
            },
            btnTitle: widget.subscriptionDetails != null
                ? 'Track Booking status'
                : 'Retry Payment',
            showIcon: false,
            iconPath: AppIcons.add,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimension.d4,
              vertical: Dimension.d6,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                  const SizedBox(height: Dimension.d4),
                  Text(
                    _getPaymentStatusMessage(store.servicePaymentStatus!),
                    style: AppTextStyle.heading5Bold
                        .copyWith(color: AppColors.grayscale900),
                  ),
                  const SizedBox(height: Dimension.d5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Info',
                        style: AppTextStyle.bodyXLBold
                            .copyWith(color: AppColors.grayscale900),
                      ),
                      const SizedBox(height: Dimension.d4),
                      ElementSpaceBetween(
                        title: 'Subsription cost',
                        description:
                            '₹ ${formatNumberWithCommas(int.parse(widget.price))}',
                      ),
                      const SizedBox(height: Dimension.d3),
                      ElementSpaceBetween(
                        title: 'Others',
                        description: '-',
                      ),
                      const SizedBox(height: Dimension.d3),
                      const Divider(color: AppColors.grayscale300),
                      const SizedBox(height: Dimension.d3),
                      ElementSpaceBetween(
                        title: 'Total Amount',
                        description:
                            '₹ ${formatNumberWithCommas(int.parse(widget.price))}',
                        isTitleBold: true,
                      ),
                      const SizedBox(height: Dimension.d3),
                      const Divider(color: AppColors.grayscale300),
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
