import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/avatar.dart';

enum BookingServiceStatus { requested, active, completed }

class BookingListTileComponent extends StatelessWidget {
  final BookingServiceStatus bookingServiceStatus;
  const BookingListTileComponent({required this.bookingServiceStatus, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(RoutesConstants.bookingServiceStatusDetailsPage, pathParameters: {'bookingServiceStatus': bookingServiceStatus.toString()});
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
                          'Varun Nair',
                          style: AppTextStyle.bodyMediumMedium
                              .copyWith(color: AppColors.grayscale700),
                        ),
                        const Spacer(),
                        if (!(bookingServiceStatus == BookingServiceStatus.requested))
                          Container(
                            height: 24,
                            width: 105,
                            alignment: const Alignment(0, 0),
                            decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              bookingServiceStatus == BookingServiceStatus.completed
                                  ? '12 Apr, 1PM'
                                  : 'Today at 1PM',
                              style: AppTextStyle.bodyMediumMedium
                                  .copyWith(color: AppColors.primary),
                            ),
                          ),
                        const SizedBox(
                          width: Dimension.d2,
                        ),
                      ],
                    ),
                    Text(
                      'Nutrition -Tele-consultation',
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
                        TextSpan(
                          text: ' Apr 10, at 10:30 AM.',
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
