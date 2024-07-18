// ignore_for_file: public_member_api_docs, sort_constructors_first, lines_longer_than_80_chars
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/routes/routes.dart';
import 'package:silver_genie/core/utils/calculate_age.dart';
import 'package:silver_genie/core/utils/launch_dialer.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/plan_display_component.dart';
import 'package:silver_genie/feature/book_services/screens/service_booking_payment_detail_screen.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/screens/subscription_details_screen.dart';
import 'package:silver_genie/feature/user_profile/services/user_services.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String id;
  const BookingDetailsScreen({
    required this.id,
    super.key,
  });

  Price getPriceById(SubscriptionDetails subscriptionDetails, int id) {
    final price = subscriptionDetails.product.prices.firstWhere(
      (price) => price.id == id,
    );

    return price;
  }

  @override
  Widget build(BuildContext context) {
    final userService = GetIt.I<UserDetailServices>();
    return SafeArea(
      child: Scaffold(
        appBar: const PageAppbar(title: 'Subscription Details'),
        backgroundColor: AppColors.white,
        body: FutureBuilder(
          future: userService.getSubscriptionById(id: int.parse(id)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingWidget(),
              );
            }
            if (snapshot.hasError) {
              return const ErrorStateComponent(
                errorType: ErrorType.somethinWentWrong,
              );
            }
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            if (snapshot.data!.isLeft()) {
              return const ErrorStateComponent(
                errorType: ErrorType.somethinWentWrong,
              );
            }
            late final SubscriptionDetails subscriptionDetails;
            try {
              subscriptionDetails = snapshot.data!.getOrElse(
                (l) => throw 'Error',
              );
            } catch (e) {
              return const ErrorStateComponent(
                errorType: ErrorType.somethinWentWrong,
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimension.d4,
                  vertical: Dimension.d5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscriptionDetails.product.name,
                      style: AppTextStyle.bodyXLMedium.copyWith(
                        color: AppColors.grayscale900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimension.d2,
                        vertical: Dimension.d2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grayscale200,
                        borderRadius: BorderRadius.circular(Dimension.d2),
                        border: Border.all(color: AppColors.grayscale300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Status',
                            style: AppTextStyle.bodyMediumMedium
                                .copyWith(color: AppColors.grayscale700),
                          ),
                          const SizedBox(height: Dimension.d1),
                          Row(
                            children: [
                              if (subscriptionDetails.paymentStatus == 'paid' &&
                                  subscriptionDetails.subscriptionStatus ==
                                      'Expired')
                                const _PaymentStatus(
                                  icon: Icons.error_outline_rounded,
                                  label: 'Payment Expired',
                                  isBlack: false,
                                )
                              else if (subscriptionDetails.paymentStatus ==
                                      'paid' ||
                                  subscriptionDetails.paymentStatus ==
                                      'partiallyPaid')
                                const _PaymentStatus(
                                  icon: Icons.check,
                                  label: 'Payment Done',
                                  isBlack: true,
                                )
                              else if (subscriptionDetails.paymentStatus ==
                                  'due')
                                const _PaymentStatus(
                                  icon: Icons.watch_later_outlined,
                                  label: 'In Progress',
                                  isBlack: true,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Dimension.d4),
                    const Divider(color: AppColors.grayscale300),
                    const SizedBox(height: Dimension.d3),
                    Text(
                      'Details',
                      style: AppTextStyle.bodyXLBold
                          .copyWith(color: AppColors.grayscale900),
                    ),
                    const SizedBox(height: Dimension.d4),
                    ExpandedAnalogComponent(
                      label: 'Service opted for',
                      value: getFormattedFamilyMembers(
                        subscriptionDetails.belongsTo
                                ?.map((member) => member.id)
                                .toList() ??
                            [],
                      ),
                    ),
                    const SizedBox(height: Dimension.d3),
                    ExpandedAnalogComponent(
                      label: 'Duration of service',
                      value:
                          '${getPriceById(subscriptionDetails, subscriptionDetails.priceId).recurringIntervalCount} ${removeLastLy(
                        getPriceById(
                          subscriptionDetails,
                          subscriptionDetails.priceId,
                        ).recurringInterval!,
                      )}',
                    ),
                    const SizedBox(height: Dimension.d3),
                    ExpandedAnalogComponent(
                      label: 'Plan start date',
                      value: formatDate(subscriptionDetails.startDate),
                    ),
                    const SizedBox(height: Dimension.d3),
                    ExpandedAnalogComponent(
                      label: 'Next renewal date',
                      value: formatDate(subscriptionDetails.expiresOn),
                    ),
                    const SizedBox(height: Dimension.d5),
                    const Divider(color: AppColors.grayscale300),
                    const SizedBox(height: Dimension.d4),
                    Text(
                      'Order Info',
                      style: AppTextStyle.bodyXLBold
                          .copyWith(color: AppColors.grayscale900),
                    ),
                    const SizedBox(height: Dimension.d3),
                    ElementSpaceBetween(
                      title: 'Subscription cost',
                      description:
                          '₹ ${formatNumberWithCommas(subscriptionDetails.amount)}',
                    ),
                    const SizedBox(height: Dimension.d3),
                    ElementSpaceBetween(title: 'Others', description: '-'),
                    const SizedBox(height: Dimension.d2),
                    const Divider(color: AppColors.grayscale300),
                    const SizedBox(height: Dimension.d2),
                    ElementSpaceBetween(
                      title: subscriptionDetails.paymentStatus == 'due'
                          ? 'Total to Pay'
                          : 'Total Paid',
                      description:
                          '₹ ${formatNumberWithCommas(subscriptionDetails.amount)}',
                      isTitleBold: true,
                    ),
                    const SizedBox(height: Dimension.d2),
                    const Divider(color: AppColors.grayscale300),
                    const SizedBox(height: Dimension.d8),
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
                        ontap: () async {
                          await launchDialer(homeStore.getMasterDataModel?.masterData
                                  .contactUs.contactNumber ??
                              '');
                        },
                        title: 'Help-Contact customer care',
                        showIcon: true,
                        iconPath: Icons.call_outlined,
                        size: ButtonSize.normal,
                        type: ButtonType.secondary,
                        expanded: true,
                        iconColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: Dimension.d4),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ElementSpaceBetween extends StatelessWidget {
  ElementSpaceBetween({
    required this.title,
    required this.description,
    this.isTitleBold = false,
    super.key,
  });
  final String title;
  final String description;
  bool isTitleBold;

  final style =
      AppTextStyle.bodyLargeMedium.copyWith(color: AppColors.grayscale900);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: isTitleBold
                ? AppTextStyle.bodyXLBold
                    .copyWith(color: AppColors.grayscale900)
                : style,
          ),
        ),
        const SizedBox(width: Dimension.d2),
        Text(
          description,
          style: style,
        ),
      ],
    );
  }
}

class _PaymentStatus extends StatelessWidget {
  const _PaymentStatus({
    required this.icon,
    required this.label,
    required this.isBlack,
  });

  final IconData icon;
  final String label;
  final bool isBlack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: isBlack ? AppColors.grayscale900 : AppColors.warning2,
          size: icon == Icons.check ? 24 : 18,
        ),
        const SizedBox(width: Dimension.d2),
        Text(
          label,
          style: AppTextStyle.bodyMediumBold.copyWith(
            color: isBlack ? AppColors.grayscale900 : AppColors.warning2,
          ),
        ),
      ],
    );
  }
}
