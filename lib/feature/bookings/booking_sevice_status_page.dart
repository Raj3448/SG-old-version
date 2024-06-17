// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/booking_service_listile_component.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/assigning_component.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';

class BookingSeviceStatusPage extends StatelessWidget {
  final BookingServiceStatus bookingServiceStatus;
  const BookingSeviceStatusPage({
    Key? key,
    required this.bookingServiceStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PageAppbar(title: 'Booking Details'),
        backgroundColor: AppColors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimension.d4),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Doctor Consultation',
                  style: AppTextStyle.bodyXLMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Service type: Health care',
                  style: AppTextStyle.bodyLargeMedium
                      .copyWith(color: AppColors.grayscale600),
                ),
                const SizedBox(
                  height: Dimension.d2,
                ),
                Container(
                  height: 58,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: Dimension.d2),
                  padding: const EdgeInsets.symmetric(horizontal: Dimension.d2),
                  decoration: BoxDecoration(
                    color: AppColors.grayscale200,
                    borderRadius: BorderRadius.circular(Dimension.d2),
                    border: Border.all(color: AppColors.grayscale300),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Booking Status',
                          style: AppTextStyle.bodyMediumMedium),
                      Row(
                        children: [
                          Icon(
                            bookingServiceStatus == BookingServiceStatus.active
                                ? AppIcons.medical_services
                                : bookingServiceStatus ==
                                        BookingServiceStatus.requested
                                    ? Icons.error_outline_outlined
                                    : AppIcons.check,
                            size: bookingServiceStatus ==
                                    BookingServiceStatus.requested
                                ? 16
                                : 14,
                            color: bookingServiceStatus ==
                                    BookingServiceStatus.requested
                                ? AppColors.warning2
                                : AppColors.grayscale800,
                          ),
                          const SizedBox(
                            width: Dimension.d2,
                          ),
                          Text(
                            bookingServiceStatus == BookingServiceStatus.active
                                ? 'Service In progress'
                                : bookingServiceStatus ==
                                        BookingServiceStatus.requested
                                    ? 'Payment Pending'
                                    : 'Service Completed',
                            style: AppTextStyle.bodyMediumBold.copyWith(
                                color: bookingServiceStatus ==
                                        BookingServiceStatus.requested
                                    ? AppColors.warning2
                                    : AppColors.grayscale800),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: AppColors.grayscale300,
                ),
                Text(
                  'Details',
                  style: AppTextStyle.bodyXLMedium
                      .copyWith(fontWeight: FontWeight.w500, height: 2.6),
                ),
                const AssigningComponent(
                  name: 'Service opted for',
                  initializeElement: 'Vinita nair',
                ),
                const SizedBox(
                  height: Dimension.d1,
                ),
                const AssigningComponent(
                  name: 'Relation',
                  initializeElement: 'Mother',
                ),
                const SizedBox(
                  height: Dimension.d1,
                ),
                const AssigningComponent(
                  name: 'Duration of service',
                  initializeElement: '1 hr ',
                ),
                const SizedBox(
                  height: Dimension.d1,
                ),
                const AssigningComponent(
                  name: 'Requested on',
                  initializeElement: '24/4/2024',
                ),
                const SizedBox(
                  height: Dimension.d1,
                ),
                const AssigningComponent(
                  name: 'Additional info',
                  initializeElement: '-',
                ),
                const Divider(
                  color: AppColors.grayscale300,
                ),
                Text(
                  'Order Info',
                  style: AppTextStyle.bodyXLMedium
                      .copyWith(fontWeight: FontWeight.w500, height: 2.4),
                ),
                _ElementSpaceBetween(
                  title: 'Critical Nurse care',
                  description: '₹ 930',
                ),
                _ElementSpaceBetween(
                    title: 'Discount(10%)', description: '-55'),
                const Divider(
                  color: AppColors.grayscale300,
                ),
                _ElementSpaceBetween(title: 'Total', description: '+855'),
                _ElementSpaceBetween(title: 'GST-18%', description: '+160'),
                const Divider(
                  color: AppColors.grayscale300,
                ),
                _ElementSpaceBetween(
                  title: 'Total to pay',
                  description: '₹ 975',
                  isTitleBold: true,
                ),
                const SizedBox(
                  height: Dimension.d8,
                ),
                SizedBox(
                  height: 48,
                  child: CustomButton(
                    ontap: () {},
                    title: 'Download invoice',
                    showIcon: true,
                    iconPath: Icons.file_download_outlined,
                    size: ButtonSize.normal,
                    type: ButtonType.secondary,
                    expanded: true,
                    iconColor: AppColors.primary,
                  ),
                ),
                const SizedBox(
                  height: Dimension.d4,
                ),
                SizedBox(
                  height: 48,
                  child: CustomButton(
                    ontap: () {},
                    title: 'Help-Contact customer care',
                    showIcon: true,
                    iconPath: Icons.call_outlined,
                    size: ButtonSize.normal,
                    type: ButtonType.secondary,
                    expanded: true,
                    iconColor: AppColors.primary,
                  ),
                ),
                const SizedBox(
                  height: Dimension.d8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ElementSpaceBetween extends StatelessWidget {
  _ElementSpaceBetween({
    required this.title,
    required this.description,
    this.isTitleBold = false,
  });
  final String title;
  final String description;
  bool isTitleBold;

  final style = AppTextStyle.bodyLargeMedium.copyWith(height: 2.4);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTitleBold
              ? AppTextStyle.bodyXLMedium.copyWith(fontWeight: FontWeight.w500)
              : style,
        ),
        Text(
          description,
          style: style,
        ),
      ],
    );
  }
}
