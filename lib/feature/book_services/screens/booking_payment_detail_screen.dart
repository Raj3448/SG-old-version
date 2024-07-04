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
import 'package:silver_genie/core/widgets/assigning_component.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/model/service_tracking_response.dart';
import 'package:silver_genie/feature/book_services/widgets/booking_status.dart';
import 'package:silver_genie/feature/bookings/booking_sevice_status_page.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';

class BookingPaymentDetailScreen extends StatefulWidget {
  final ServiceTrackerResponse paymentDetails;
  const BookingPaymentDetailScreen({
    required this.paymentDetails,
    Key? key,
  }) : super(key: key);

  @override
  State<BookingPaymentDetailScreen> createState() =>
      _BookingPaymentDetailScreenState();
}

class _BookingPaymentDetailScreenState
    extends State<BookingPaymentDetailScreen> {
  final store = GetIt.I<ProductListingStore>();
  bool pytmStatusLoading = false;
  @override
  void initState() {
    reaction((_) => store.paymentStatus, (paymentStatus) {
      if (paymentStatus != null) {
        if (paymentStatus == PaymentStatus.success ||
            paymentStatus == PaymentStatus.failure) {
          store.getPaymentStatus(id: widget.paymentDetails.id.toString());
        }
        store.paymentStatus = null;
      }
    });
    reaction((_) => store.paymentStatusModel, (paymentStatusModel) {
      if (paymentStatusModel != null) {
        context.pushReplacementNamed(RoutesConstants.paymentScreen,
            extra: {'paymentStatusModel': paymentStatusModel});
        store.paymentStatusModel = null;
      }
    });
    super.initState();
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
              appBar: const PageAppbar(title: 'Book Service'),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BookingStatus(
                      currentStep: BookingStep.payment,
                    ),
                    Text('Order Summery',
                        style: AppTextStyle.bodyLargeSemiBold.copyWith(
                            fontSize: 18,
                            color: AppColors.grayscale900,
                            height: 2.6)),
                    const SizedBox(
                      height: Dimension.d2,
                    ),
                    AssigningComponent(
                      name: 'Service opted for',
                      initializeElement: widget.paymentDetails.memberName,
                    ),
                    const SizedBox(
                      height: Dimension.d2,
                    ),
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => !widget
                                .paymentDetails.metaData[index].private
                            ? AssigningComponent(
                                name: widget.paymentDetails.metaData[index].key,
                                initializeElement:
                                    widget.paymentDetails.metaData[index].value,
                              )
                            : const SizedBox(),
                        separatorBuilder: (context, index) =>
                            !widget.paymentDetails.metaData[index].private
                                ? const SizedBox(
                                    height: Dimension.d3,
                                  )
                                : const SizedBox(),
                        itemCount: widget.paymentDetails.metaData.length),
                    const SizedBox(
                      height: Dimension.d4,
                    ),
                    const Divider(
                      color: AppColors.line,
                    ),
                    ElementSpaceBetween(
                      title: 'Total to pay',
                      description:
                          '₹ ${formatNumberWithCommas(widget.paymentDetails.amount.toInt())}',
                      isTitleBold: true,
                    ),
                  ],
                ),
              ),
            ),
            if (store.pytmStatusLoading)
              const Material(color: Colors.transparent, child: LoadingWidget())
          ],
        );
      },
    );
  }

  void _proceedToPay() {
    print(widget.paymentDetails.id);
    GetIt.I<PaymentService>().openCheckout(
        amount: widget.paymentDetails.amount,
        orderId: widget.paymentDetails.orderId,
        razorpayApiKey: widget.paymentDetails.razorpayApiKey);
  }

  String formatNumberWithCommas(int number) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(number);
  }
}
