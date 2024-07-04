import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/payment/payment_services.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/model/payment_status_model.dart';
import 'package:silver_genie/feature/book_services/widgets/booking_status.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';

class PaymentScreen extends StatelessWidget {
  final PaymentStatusModel paymentStatusModel;

  const PaymentScreen({required this.paymentStatusModel, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentStatus = _isPaymentStatusSuccess();
    
    return Observer(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: const PageAppbar(title: 'Book Service'),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FixedButton(
            ontap: () {
              GetIt.I<ProductListingStore>().servicePaymentInfoGotSuccess =
                  null;
              context.pop();
            },
            btnTitle: 'Back',
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
                        ? 'assets/icon/success.svg' : paymentStatus == PaymentStatus.pending
                        ? 'assets/icon/pending.svg' : 'assets/icon/failure.svg',
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
                  _buildNoteContainer(context),
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

  Widget _buildNoteContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).orientation == Orientation.landscape
          ? 80
          : 115,
      padding: const EdgeInsets.symmetric(
          horizontal: Dimension.d2, vertical: Dimension.d2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimension.d1),
        color: AppColors.secondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Note',
                  style: AppTextStyle.bodyMediumSemiBold.copyWith(height: 2)),
              const SizedBox(width: Dimension.d1),
              const Icon(Icons.error_outline_rounded, size: 20),
            ],
          ),
          const SizedBox(height: Dimension.d1),
          Text(
            'Please complete the payment by clicking the payment link sent to your registered mobile number.',
            style: AppTextStyle.bodyMediumMedium
                .copyWith(color: AppColors.grayscale800),
          ),
        ],
      ),
    );
  }

  PaymentStatus _isPaymentStatusSuccess() {
    if (paymentStatusModel.paymentStatus == 'due' &&
        paymentStatusModel.status == 'requested') {
      return PaymentStatus.pending;
    }
    if(paymentStatusModel.paymentStatus == 'paid' &&
        paymentStatusModel.status == 'processing') {
      return PaymentStatus.success;
    }else{
      return PaymentStatus.failure;
    }
  }
}
