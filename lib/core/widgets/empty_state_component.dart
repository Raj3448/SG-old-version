// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/booking_service_listile_component.dart';

class EmptyStateComponent extends StatelessWidget {
  final BookingServiceStatus bookingServiceStatus;
  String? emptyDescription;
  EmptyStateComponent(
      {Key? key,
      this.bookingServiceStatus = BookingServiceStatus.requested,
      this.emptyDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = bookingServiceStatus == BookingServiceStatus.requested
        ? 'requested bookings'
        : bookingServiceStatus == BookingServiceStatus.active
            ? 'active bookings'.tr()
            : "You haven't completed any bookings yet.".tr();
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icon/EmptyState.svg',
          ),
          Text(
            'Nothing found',
            style: AppTextStyle.bodyXLBold.copyWith(fontSize: 20, height: 2.4),
          ),
          Text(
            emptyDescription != null
                ? emptyDescription!
                : bookingServiceStatus == BookingServiceStatus.completed
                    ? text
                    : 'You don’t have any $text',
            style: AppTextStyle.bodyLargeMedium.copyWith(height: 2),
          )
        ],
      ),
    );
  }
}
