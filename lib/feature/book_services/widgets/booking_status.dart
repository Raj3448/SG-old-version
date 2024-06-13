import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';

enum BookingStep { serviceDetails, payment, bookingDetails }

class BookingStatus extends StatefulWidget {
  const BookingStatus({this.currentStep =  BookingStep.serviceDetails,Key? key}) : super(key: key);
  final BookingStep currentStep;
  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
  

  Widget buildStatusCircle(int step, bool isEnabled) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isEnabled ? AppColors.secondary : AppColors.grayscale200,
        border: isEnabled ? Border.all(color: AppColors.primary) : null,
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        '$step',
        style: AppTextStyle.bodyLargeMedium.copyWith(
          color: isEnabled ? AppColors.primary : AppColors.grayscale600,
        ),
      ),
    );
  }

  Widget buildStatusText(String text, bool isEnabled) {
    return Text(
      text,
      style: AppTextStyle.bodyMediumMedium.copyWith(
        color: isEnabled ? AppColors.primary : AppColors.grayscale900,
      ),
    );
  }

  bool isStepEnabled(BookingStep step) {
    switch (step) {
      case BookingStep.serviceDetails:
        return widget.currentStep.index >= BookingStep.serviceDetails.index;
      case BookingStep.payment:
        return widget.currentStep.index >= BookingStep.payment.index;
      case BookingStep.bookingDetails:
        return widget.currentStep.index >= BookingStep.bookingDetails.index;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildStatusCircle(1, isStepEnabled(BookingStep.serviceDetails)),
            const SizedBox(width: 7),
            const SizedBox(
              width: 68,
              child: Divider(color: AppColors.primary),
            ),
            const SizedBox(width: 7),
            buildStatusCircle(2, isStepEnabled(BookingStep.payment)),
            const SizedBox(width: 7),
            const SizedBox(
              width: 68,
              child: Divider(color: AppColors.primary),
            ),
            const SizedBox(width: 7),
            buildStatusCircle(3, isStepEnabled(BookingStep.bookingDetails)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildStatusText('Service details', isStepEnabled(BookingStep.serviceDetails)),
            buildStatusText('Payment', isStepEnabled(BookingStep.payment)),
            buildStatusText('Booking details', isStepEnabled(BookingStep.bookingDetails)),
          ],
        ),
      ],
    );
  }
}
