// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/payment/payment_services.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/utils/calculate_age.dart';
import 'package:silver_genie/core/widgets/active_plan.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/core/widgets/plan_display_component.dart';
import 'package:silver_genie/feature/book_services/screens/service_booking_payment_detail_screen.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  const SubscriptionDetailsScreen({
    required this.price,
    required this.subscriptionData,
    required this.isCouple,
    super.key,
  });

  final String price;
  final SubscriptionData subscriptionData;
  final bool isCouple;

  @override
  State<SubscriptionDetailsScreen> createState() =>
      _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  final memberStore = GetIt.I<MembersStore>();
  final store = GetIt.I<ProductListingStore>();

  late ReactionDisposer _reactionDisposer1;
  late ReactionDisposer _reactionDisposer2;
  @override
  void initState() {
    _reactionDisposer1 = reaction((_) => store.paymentStatus, (paymentStatus) {
      if (paymentStatus != null) {
        if (paymentStatus == PaymentStatus.failure) {
          context.pushNamed(
            RoutesConstants.subscriptionPaymentScreen,
            extra: {
              'subscriptionDetails': null,
              'priceId': widget.subscriptionData.id.toString(),
              'price': widget.price,
            },
          );
        }
        if (paymentStatus == PaymentStatus.success) {
          store.getSubscriptionPaymentStatus(
            id: widget.subscriptionData.id.toString(),
          );
        }
        store.paymentStatus = null;
      }
    });
    _reactionDisposer2 = reaction((_) => store.subscrpaymentStatusModel,
        (subscrpaymentStatusModel) {
      if (subscrpaymentStatusModel != null) {
        context.pushReplacementNamed(
          RoutesConstants.subscriptionPaymentScreen,
          extra: {
            'subscriptionDetails': subscrpaymentStatusModel,
            'priceId': widget.subscriptionData.id.toString(),
            'price': widget.price,
          },
        );
        store.subscrpaymentStatusModel = null;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    store.subscrpaymentStatusModel = null;
    _reactionDisposer1();
    _reactionDisposer2();
    super.dispose();
  }

  Price getPriceById(SubscriptionData subscriptionData, int id) {
    final price = subscriptionData.product.prices.firstWhere(
      (price) => price.id == id,
    );

    return price;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.white,
              appBar: const PageAppbar(title: 'Book subscription'),
              bottomNavigationBar: SafeArea(
                top: false,
                child: FixedButton(
                  ontap: () {
                    GetIt.I<PaymentService>().openCheckout(
                      orderId: widget.subscriptionData.razorpaySubscriptionId,
                      razorpayApiKey: widget.subscriptionData.razorpayApiKey,
                      isSubscription: true,
                    );
                  },
                  btnTitle: 'Proceed to Pay',
                  showIcon: false,
                  iconPath: AppIcons.add,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(top: 32),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isCouple
                            ? '${widget.subscriptionData.product.name.split(' ').first} plan (Couple)'
                            : '${widget.subscriptionData.product.name.split(' ').first} plan (Single)',
                        style: AppTextStyle.bodyXLMedium,
                      ),
                      const SizedBox(height: Dimension.d6),
                      const Text(
                        'Details',
                        style: AppTextStyle.bodyLargeMedium,
                      ),
                      const SizedBox(height: Dimension.d4),
                      _DetailsBox(
                        serviceOptedFor: getFormattedFamilyMembers(
                          widget.subscriptionData.familyMemberIds,
                        ),
                        duration:
                            '${getPriceById(widget.subscriptionData, widget.subscriptionData.priceId).recurringIntervalCount} ${removeLastLy(
                          getPriceById(
                            widget.subscriptionData,
                            widget.subscriptionData.priceId,
                          ).recurringInterval!,
                        )}',
                        startDate:
                            formatDate(widget.subscriptionData.startDate),
                        renewalDate:
                            formatDate(widget.subscriptionData.expiresOn),
                      ),
                      const SizedBox(height: Dimension.d4),
                      const Divider(color: AppColors.line),
                      const SizedBox(height: Dimension.d4),
                      const Text(
                        'Payment details',
                        style: AppTextStyle.bodyLargeMedium,
                      ),
                      const SizedBox(height: Dimension.d3),
                      _PaymentTile(
                        title: 'Subscription cost',
                        value:
                            '₹ ${formatNumberWithCommas(getPriceById(widget.subscriptionData, widget.subscriptionData.priceId).unitAmount)}',
                      ),
                      const SizedBox(height: Dimension.d3),
                      const _PaymentTile(title: 'Others', value: '-'),
                      const SizedBox(height: Dimension.d4),
                      const Divider(color: AppColors.line),
                      const SizedBox(height: Dimension.d4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total to pay',
                            style: AppTextStyle.bodyXLMedium,
                          ),
                          Text(
                            '₹ ${formatNumberWithCommas(getPriceById(widget.subscriptionData, widget.subscriptionData.priceId).unitAmount)}',
                            style: AppTextStyle.bodyLargeMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (store.pytmStatusLoading)
              const Material(color: Colors.transparent, child: LoadingWidget()),
          ],
        );
      },
    );
  }
}

class _DetailsBox extends StatelessWidget {
  const _DetailsBox({
    required this.serviceOptedFor,
    required this.duration,
    required this.startDate,
    required this.renewalDate,
  });

  final String serviceOptedFor;
  final String duration;
  final String startDate;
  final String renewalDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpandedAnalogComponent(
          label: 'Service opted for',
          value: serviceOptedFor,
        ),
        const SizedBox(height: Dimension.d3),
        ExpandedAnalogComponent(label: 'Duration of service', value: duration),
        const SizedBox(height: Dimension.d3),
        ExpandedAnalogComponent(label: 'Plan start date', value: startDate),
        const SizedBox(height: Dimension.d3),
        ExpandedAnalogComponent(label: 'Next renewal date', value: renewalDate),
      ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyle.bodyMediumMedium),
        Text(value, style: AppTextStyle.bodyMediumMedium),
      ],
    );
  }
}

String getFormattedFamilyMembers(List<int> ids) {
  final memberStore = GetIt.I<MembersStore>();
  var names = <String>[];
  for (final id in ids) {
    final member = memberStore.findMemberById(id);
    if (member != null) {
      names.add(member.name);
    }
  }
  if (names.isEmpty) {
    return '';
  }
  if (names.length > 2) {
    names = names.sublist(0, 2);
  }
  if (names.length > 1) {
    return names.join(' & ');
  }

  return names.first;
}
