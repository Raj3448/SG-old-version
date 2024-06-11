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
    return Observer(
      builder: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: store.paymentEnabled == false &&
                            store.detailsEnabled == false
                        ? AppColors.secondary
                        : AppColors.grayscale200,
                    border: store.paymentEnabled == false &&
                            store.detailsEnabled == false
                        ? Border.all(color: AppColors.primary)
                        : null,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    '1',
                    style: AppTextStyle.bodyLargeMedium.copyWith(
                      color: store.paymentEnabled == false &&
                              store.detailsEnabled == false
                          ? AppColors.primary
                          : AppColors.grayscale600,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                const SizedBox(
                  width: 68,
                  child: Divider(color: AppColors.primary),
                ),
                const SizedBox(width: 7),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: store.paymentEnabled
                        ? AppColors.secondary
                        : AppColors.grayscale200,
                    border: store.paymentEnabled
                        ? Border.all(color: AppColors.primary)
                        : null,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    '2',
                    style: AppTextStyle.bodyLargeMedium.copyWith(
                      color: store.paymentEnabled
                          ? AppColors.primary
                          : AppColors.grayscale600,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                const SizedBox(
                  width: 68,
                  child: Divider(color: AppColors.primary),
                ),
                const SizedBox(width: 7),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: store.detailsEnabled
                        ? AppColors.secondary
                        : AppColors.grayscale200,
                    border: store.detailsEnabled
                        ? Border.all(color: AppColors.primary)
                        : null,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    '3',
                    style: AppTextStyle.bodyLargeMedium.copyWith(
                      color: store.detailsEnabled
                          ? AppColors.primary
                          : AppColors.grayscale600,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Service details',
                  style: AppTextStyle.bodyMediumMedium.copyWith(
                    color: store.paymentEnabled == false &&
                            store.detailsEnabled == false
                        ? AppColors.grayscale900
                        : AppColors.grayscale600,
                  ),
                ),
                Text(
                  'Payment',
                  style: AppTextStyle.bodyMediumMedium.copyWith(
                    color: store.paymentEnabled
                        ? AppColors.grayscale900
                        : AppColors.grayscale600,
                  ),
                ),
                Text(
                  'Booking details',
                  style: AppTextStyle.bodyMediumMedium.copyWith(
                    color: store.detailsEnabled
                        ? AppColors.grayscale900
                        : AppColors.grayscale600,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
