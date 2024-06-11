import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/book_services/store/services_store.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<ServicesStore>();
    return Observer(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: const PageAppbar(title: 'Book Service'),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FixedButton(
            ontap: () {
              GoRouter.of(context)
                  .pushNamed(RoutesConstants.bookingDetailsScreen);
              store
                ..paymentEnabled = !store.paymentEnabled
                ..detailsEnabled = !store.detailsEnabled;
            },
            btnTitle: 'Book now',
            showIcon: false,
            iconPath: AppIcons.add,
          ),
          body: Padding(
            padding: const EdgeInsets.all(Dimension.d3),
            child: Column(
              children: [
                //BookingStatus(),
                SvgPicture.asset('assets/icon/failure.svg'),

                Text(
                  'Payment Failure',
                  style: AppTextStyle.bodyXLSemiBold
                      .copyWith(fontSize: 20, height: 2.8),
                ),

                Container(
                  width: double.infinity,
                  height: 115,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimension.d2, vertical: Dimension.d2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimension.d1),
                      color: AppColors.secondary),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Note',
                            style: AppTextStyle.bodyMediumSemiBold.copyWith(
                              height: 2,
                            ),
                          ),
                          const SizedBox(
                            width: Dimension.d1,
                          ),
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 20,
                          )
                        ],
                      ),
                      Text(
                        'Please complete the payment by clicking the payment link sent to your registered mobile number.',
                        style: AppTextStyle.bodyMediumMedium
                            .copyWith(color: AppColors.grayscale800),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
