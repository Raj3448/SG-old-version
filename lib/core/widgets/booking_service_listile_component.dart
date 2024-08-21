// ignore_for_file: lines_longer_than_80_chars

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/feature/bookings/model/booking_service_model.dart';

enum BookingServiceStatus { requested, active, completed }

class BookingListTileComponent extends StatelessWidget {
  const BookingListTileComponent({
    required this.bookingServiceStatus,
    required this.bookingServiceModel,
    super.key,
  });
  final BookingServiceStatus bookingServiceStatus;
  final Service bookingServiceModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RoutesConstants.bookingServiceStatusDetailsPage,
          pathParameters: {
            'serviceId': bookingServiceModel.id.toString(),
          },
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
        height: BookingServiceStatus.active == bookingServiceStatus ? 100 : 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Avatar.fromSize(
                          imgPath: bookingServiceModel
                                      .requestedFor.first.profileImg ==
                                  null
                              ? ''
                              : '${Env.serverUrl}${bookingServiceModel.requestedFor.first.profileImg!.url}',
                          size: AvatarSize.size16,
                        ),
                        const SizedBox(
                          width: Dimension.d2,
                        ),
                        Expanded(
                          child: Text(
                            '${bookingServiceModel.requestedFor.first.firstName} ${bookingServiceModel.requestedFor.first.lastName}',
                            style: AppTextStyle.bodyMediumMedium.copyWith(
                              color: AppColors.grayscale700,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (!(bookingServiceModel.paymentStatus == 'paid' &&
                                bookingServiceStatus ==
                                    BookingServiceStatus.requested) &&
                            bookingServiceModel.status != 'completed')
                          Container(
                            height: 24,
                            width: 105,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimension.d1,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightBlue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              (bookingServiceStatus ==
                                          BookingServiceStatus.requested) &&
                                      bookingServiceModel.paymentStatus == 'due'
                                  ? 'Due'
                                  : (bookingServiceModel.status == 'rejected')
                                      ? 'Rejected'
                                      : formatDateTime(
                                          bookingServiceModel.requestedAt
                                              .toLocal(),
                                        ),
                              style: AppTextStyle.bodyMediumMedium
                                  .copyWith(color: AppColors.primary),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        const SizedBox(
                          width: Dimension.d2,
                        ),
                      ],
                    ),
                    Text(
                      bookingServiceModel.product.name,
                      style: AppTextStyle.bodyLargeMedium.copyWith(
                        color: AppColors.grayscale900,
                      ),
                    ),
                    if (!(bookingServiceStatus == BookingServiceStatus.active))
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Requested on:',
                              style: AppTextStyle.bodyMediumMedium
                                  .copyWith(color: AppColors.grayscale700),
                            ),
                            const WidgetSpan(
                              child: SizedBox(
                                width: Dimension.d2,
                              ),
                            ),
                            TextSpan(
                              text: formatDateTimeWithMin(
                                bookingServiceModel.requestedAt.toLocal(),
                              ),
                              style: AppTextStyle.bodyMediumMedium
                                  .copyWith(color: AppColors.grayscale900),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatDateTime(DateTime dateTime) {
  final dayFormat = DateFormat('d MMM');
  final timeFormat = DateFormat('h a');

  final formattedDay = dayFormat.format(dateTime);
  final formattedTime = timeFormat.format(dateTime).toUpperCase();

  return '$formattedDay, $formattedTime';
}

String formatDateTimeWithMin(DateTime dateTime) {
  final dayFormat = DateFormat('d MMM');
  final timeFormat = DateFormat('h:mm a');

  final formattedDay = dayFormat.format(dateTime);
  final formattedTime = timeFormat.format(dateTime).toUpperCase();

  return '$formattedDay, $formattedTime';
}
