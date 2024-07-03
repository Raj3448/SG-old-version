import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/payment/payment_services.dart';
import 'package:silver_genie/core/widgets/assigning_component.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/model/service_tracking_response.dart';
import 'package:silver_genie/feature/book_services/widgets/booking_status.dart';
import 'package:silver_genie/feature/bookings/booking_sevice_status_page.dart';

class BookingPaymentDetailScreen extends StatelessWidget {
  final ServiceTrackerResponse paymentDetails;
  const BookingPaymentDetailScreen({
    required this.paymentDetails,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FixedButton(
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
                    fontSize: 18, color: AppColors.grayscale900, height: 2.6)),
            AssigningComponent(
              name: 'Service opted for',
              initializeElement: paymentDetails.memberName,
            ),
            const SizedBox(
              height: Dimension.d2,
            ),
            ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => !paymentDetails
                        .metaData[index].private
                    ? AssigningComponent(
                        name: paymentDetails.metaData[index].key,
                        initializeElement: paymentDetails.metaData[index].value,
                      )
                    : const SizedBox(),
                separatorBuilder: (context, index) =>
                    !paymentDetails.metaData[index].private
                        ? const SizedBox(
                            height: Dimension.d2,
                          )
                        : const SizedBox(),
                itemCount: paymentDetails.metaData.length),
            const Divider(
              color: AppColors.line,
            ),
            Text('Payment breakdown',
                style: AppTextStyle.bodyLargeSemiBold.copyWith(
                    fontSize: 18, color: AppColors.grayscale900, height: 2.6)),
            ElementSpaceBetween(title: 'Base rate', description: '₹ 1,200'),
            ElementSpaceBetween(
                title: '60 days × 12 hours rate', description: '₹ 72,000'),
            ElementSpaceBetween(title: 'Other', description: '₹ 2,000'),
            const Divider(
              color: AppColors.line,
            ),
            ElementSpaceBetween(
              title: 'Total to pay',
              description: '₹ 75,400',
              isTitleBold: true,
            ),
          ],
        ),
      ),
    );
  }
}

void _proceedToPay() {
  GetIt.I<PaymentService>().openCheckout(amount: 10, receipt: '');
}
