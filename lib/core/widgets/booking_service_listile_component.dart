import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/feature/bookings/model/booking_service_model.dart';

enum BookingServiceStatus { requested, active, completed }

class BookingListTileComponent extends StatelessWidget {
  final BookingServiceStatus bookingServiceStatus;
  final BookingServiceModel bookingServiceModel;
  const BookingListTileComponent(
      {required this.bookingServiceStatus,
      required this.bookingServiceModel,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(RoutesConstants.bookingServiceStatusDetailsPage,
            pathParameters: {
              'bookingServiceStatus': bookingServiceStatus.toString()
            });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
        height: BookingServiceStatus.active == bookingServiceStatus ? 100 : 110,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: AppColors.grayscale300)),
        child: Row(
          children: [
            Container(
              width: 8,
              height: double.infinity,
              decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8))),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Avatar.fromSize(
                          imgPath: '',
                          size: AvatarSize.size16,
                        ),
                        const SizedBox(
                          width: Dimension.d2,
                        ),
                        Text(
                          bookingServiceModel.memberName,
                          style: AppTextStyle.bodyMediumMedium
                              .copyWith(color: AppColors.grayscale700),
                        ),
                        const Spacer(),
                        if (!(bookingServiceStatus ==
                            BookingServiceStatus.requested))
                          Container(
                            height: 24,
                            width: 105,
                            alignment: const Alignment(0, 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimension.d1),
                            decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              bookingServiceStatus ==
                                      BookingServiceStatus.completed
                                  ? formatDateTime(
                                      bookingServiceModel.completedDate ??
                                          DateTime.now())
                                  : formatDateTime(
                                      bookingServiceModel.requestedDate),
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
                      bookingServiceModel.serviceName,
                      style: AppTextStyle.bodyLargeMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.grayscale900),
                    ),
                    if (!(bookingServiceStatus == BookingServiceStatus.active))
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: 'Requested on:',
                          style: AppTextStyle.bodyMediumMedium
                              .copyWith(color: AppColors.grayscale700),
                        ),
                        const WidgetSpan(
                            child: SizedBox(
                          width: Dimension.d2,
                        )),
                        TextSpan(
                          text:
                              formatDateTime(bookingServiceModel.requestedDate),
                          style: AppTextStyle.bodyMediumMedium
                              .copyWith(color: AppColors.grayscale900),
                        )
                      ])),
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
  final DateFormat dayFormat = DateFormat('d MMM');
  final DateFormat timeFormat = DateFormat('h a');
  
  String formattedDay = dayFormat.format(dateTime);
  String formattedTime = timeFormat.format(dateTime).toUpperCase();

  return '$formattedDay, $formattedTime';
}