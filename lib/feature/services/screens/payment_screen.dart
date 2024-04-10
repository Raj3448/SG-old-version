import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/fixed_button.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/services/store/services_store.dart';
import 'package:silver_genie/feature/services/widgets/booking_status.dart';

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
          body: const Column(
            children: [
              BookingStatus(),
            ],
          ),
        );
      },
    );
  }
}
