import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/avatar.dart';

class BookingListTileComponent extends StatelessWidget {
  const BookingListTileComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(RoutesConstants.bookingServiceStatusDetailsPage);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
        height: 110,
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
                        Container(
                          height: 24,
                          width: 105,
                          alignment: const Alignment(0, 0),
                          decoration: BoxDecoration(
                              color: AppColors.lightBlue,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            'Today at 1PM',
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
                      'Nutrition -Tele-consultation ',
                      style: AppTextStyle.bodyLargeMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.grayscale900),
                    ),
                    Text(
                      'Consultant: Dr.Vijay Bharvag',
                      style: AppTextStyle.bodyMediumMedium
                          .copyWith(color: AppColors.grayscale700),
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