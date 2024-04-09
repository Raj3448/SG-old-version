import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/feature/bookings/bookings_screen.dart';
import 'package:silver_genie/feature/home/home_screen.dart';
import 'package:silver_genie/feature/main/store/main_store.dart';
import 'package:silver_genie/feature/members/screens/members_screen.dart';
import 'package:silver_genie/feature/services/screens/services_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const ServicesScreen(),
      const BookingsScreen(),
      const MembersScreen(),
    ];

    final store = GetIt.I<MainStore>();
    return Scaffold(
      body: SafeArea(
        child: Observer(
          builder: (_) {
            return pages[store.currentIndex];
          },
        ),
      ),
      bottomNavigationBar: Observer(
        builder: (context) {
          return SizedBox(
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                border: Border.all(color: AppColors.line),
              ),
              child: BottomNavigationBar(
                backgroundColor: AppColors.white,
                elevation: 10,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                selectedLabelStyle:
                    AppTextStyle.bodyMediumBold.copyWith(height: 2),
                currentIndex: store.currentIndex,
                unselectedLabelStyle:
                    AppTextStyle.bodyMediumMedium.copyWith(height: 2),
                selectedItemColor: AppColors.primary,
                selectedIconTheme:
                    const IconThemeData(color: AppColors.primary),
                onTap: (value) {
                  store.currentIndex = value;
                },
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    label: 'Home'.tr(),
                    icon: const Icon(AppIcons.home),
                  ),
                  BottomNavigationBarItem(
                    label: 'Services'.tr(),
                    icon: const Icon(AppIcons.medical_services),
                  ),
                  BottomNavigationBarItem(
                    label: 'Booking'.tr(),
                    icon: const Icon(AppIcons.calendar),
                  ),
                  BottomNavigationBarItem(
                    label: 'Members'.tr(),
                    icon: const Icon(AppIcons.family),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
