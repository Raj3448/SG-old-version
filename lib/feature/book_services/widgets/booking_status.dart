import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/feature/book_services/store/services_store.dart';

class BookingStatus extends StatelessWidget {
  const BookingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<ServicesStore>();

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

    return Observer(
      builder: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildStatusCircle(1, store.detailsEnabled),
                const SizedBox(width: 7),
                const SizedBox(
                  width: 68,
                  child: Divider(color: AppColors.primary),
                ),
                const SizedBox(width: 7),
                buildStatusCircle(2, store.paymentEnabled),
                const SizedBox(width: 7),
                const SizedBox(
                  width: 68,
                  child: Divider(color: AppColors.primary),
                ),
                const SizedBox(width: 7),
                buildStatusCircle(3, store.bookingDetailEnabled),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildStatusText('Service details', store.detailsEnabled),
                buildStatusText('Payment', store.paymentEnabled),
                buildStatusText('Booking details', store.bookingDetailEnabled),
              ],
            ),
          ],
        );
      },
    );
  }
}