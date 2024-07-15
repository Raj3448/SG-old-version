// ignore_for_file: lines_longer_than_80_chars

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/payment/payment_services.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/model/service_tracking_response.dart';
import 'package:silver_genie/feature/book_services/widgets/booking_status.dart';
import 'package:silver_genie/feature/bookings/service_booking_details_screen.dart';
import 'package:silver_genie/feature/bookings/store/booking_service_store.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';

class ServiceBookingPaymentDetailScreen extends StatefulWidget {
  final ServiceTrackerResponse paymentDetails;
  const ServiceBookingPaymentDetailScreen({
    required this.paymentDetails,
    Key? key,
  }) : super(key: key);

  @override
  State<ServiceBookingPaymentDetailScreen> createState() =>
      _ServiceBookingPaymentDetailScreenState();
}

class _ServiceBookingPaymentDetailScreenState
    extends State<ServiceBookingPaymentDetailScreen> {
  final store = GetIt.I<ProductListingStore>();
  final memberStore = GetIt.I<MembersStore>();
  final bookingServiceStore = GetIt.I<BookingServiceStore>();
  bool pytmStatusLoading = false;
  late ReactionDisposer _reactionDisposer1;
  late ReactionDisposer _reactionDisposer2;
  @override
  void initState() {
    _reactionDisposer1 = reaction((_) => store.paymentStatus, (paymentStatus) {
      if (paymentStatus != null) {
        if (paymentStatus == PaymentStatus.failure) {
          context.pushNamed(
            RoutesConstants.paymentScreen,
            extra: {
              'paymentStatusModel': null,
              'priceDetails': widget.paymentDetails.priceDetails,
              'id': widget.paymentDetails.id.toString(),
            },
          );
        }
        if (paymentStatus == PaymentStatus.success) {
          store.getPaymentStatus(id: widget.paymentDetails.id.toString());
          memberStore.refresh();
        }
        store.paymentStatus = null;
        bookingServiceStore.refresh();
      }
    });
    _reactionDisposer2 =
        reaction((_) => store.servicePaymentStatusModel, (paymentStatusModel) {
      if (paymentStatusModel != null) {
        context.pushReplacementNamed(
          RoutesConstants.paymentScreen,
          extra: {
            'paymentStatusModel': paymentStatusModel,
            'priceDetails': null,
            'id': widget.paymentDetails.id.toString(),
          },
        );
        store.servicePaymentStatusModel = null;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    store.servicePaymentStatusModel = null;
    _reactionDisposer1();
    _reactionDisposer2();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.white,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FixedButton(
                ontap: _proceedToPay,
                btnTitle: 'Proceed to pay',
                showIcon: false,
                iconPath: AppIcons.add,
              ),
              appBar: PageAppbar(title: 'Book Service'.tr()),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BookingStatus(
                        currentStep: BookingStep.payment,
                      ),
                      Text(
                        'Order Summery',
                        style: AppTextStyle.bodyLargeSemiBold.copyWith(
                          fontSize: 18,
                          color: AppColors.grayscale900,
                          height: 2.6,
                        ),
                      ),
                      const SizedBox(
                        height: Dimension.d2,
                      ),
                      ExpandedAnalogComponent(
                        label: 'Service opted for',
                        value: widget.paymentDetails.memberName,
                      ),
                      const SizedBox(
                        height: Dimension.d2,
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => !widget
                                .paymentDetails.metaData[index].private
                            ? ExpandedAnalogComponent(
                                label:
                                    widget.paymentDetails.metaData[index].key,
                                value:
                                    widget.paymentDetails.metaData[index].value,
                              )
                            : const SizedBox(),
                        separatorBuilder: (context, index) =>
                            !widget.paymentDetails.metaData[index].private
                                ? const SizedBox(
                                    height: Dimension.d3,
                                  )
                                : const SizedBox(),
                        itemCount: widget.paymentDetails.metaData.length,
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
                        title: widget.paymentDetails.priceDetails.products.first
                            .displayName,
                        description:
                            '₹ ${formatNumberWithCommas(widget.paymentDetails.priceDetails.products.first.price.toInt())}',
                      ),
                      const Divider(
                        color: AppColors.line,
                      ),
                      ElementSpaceBetween(
                        title:
                            '${widget.paymentDetails.priceDetails.products.first.displayName}  x  ${widget.paymentDetails.priceDetails.products.first.quantity}',
                        description:
                            '₹ ${formatNumberWithCommas(widget.paymentDetails.amount.toInt())}',
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
                            '₹ ${formatNumberWithCommas(widget.paymentDetails.amount.toInt())}',
                        isTitleBold: true,
                      ),
                      const SizedBox(
                        height: Dimension.d20,
                      ),
                      const SizedBox(
                        height: Dimension.d4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (store.pytmStatusLoading)
              const Material(color: Colors.transparent, child: LoadingWidget()),
          ],
        );
      },
    );
  }

  void _proceedToPay() {
    GetIt.I<PaymentService>().openCheckout(
      orderId: widget.paymentDetails.orderId,
      razorpayApiKey: widget.paymentDetails.razorpayApiKey,
    );
  }
}

String formatNumberWithCommas(int number) {
  final formatter = NumberFormat('#,##0');
  return formatter.format(number);
}
