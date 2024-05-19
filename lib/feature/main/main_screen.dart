import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const Appbar(),
        backgroundColor: AppColors.white,
        body: widget.child,
        bottomNavigationBar: SizedBox(
          height: 70,
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
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              selectedLabelStyle: AppTextStyle.bodyMediumSemiBold,
              currentIndex: _calculateSelectedIndex(context),
              unselectedLabelStyle: AppTextStyle.bodyMediumMedium,
              selectedItemColor: AppColors.primary,
              selectedIconTheme: const IconThemeData(color: AppColors.primary),
              onTap: onTap,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: 'Home'.tr(),
                  icon: const Padding(
                    padding: EdgeInsets.only(top: 4, left: 20, right: 20),
                    child: Icon(AppIcons.home, size: 16),
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Services'.tr(),
                  icon: const Padding(
                    padding: EdgeInsets.only(top: 4, left: 20, right: 20),
                    child: Icon(AppIcons.medical_services, size: 16),
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Booking'.tr(),
                  icon: const Padding(
                    padding: EdgeInsets.only(top: 4, left: 20, right: 20),
                    child: Icon(AppIcons.calendar, size: 16),
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Members'.tr(),
                  icon: const Padding(
                    padding: EdgeInsets.only(top: 4, left: 20, right: 20),
                    child: Icon(AppIcons.family, size: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final route = GoRouter.of(context);
    final location = route.routeInformationProvider.value.uri.path;

    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/service')) {
      return 1;
    }
    if (location.startsWith('/bookings')) {
      return 2;
    }
    if (location.startsWith('/members')) {
      return 3;
    }
    return 0;
  }

  void onTap(int value) {
    switch (value) {
      case 0:
        return GoRouter.of(context).goNamed(RoutesConstants.homeRoute);
      case 1:
        return GoRouter.of(context).goNamed(RoutesConstants.serviceRoute);
      case 2:
        return GoRouter.of(context).goNamed(RoutesConstants.bookingsRoute);
      default:
        return GoRouter.of(context).goNamed(RoutesConstants.membersRoute);
    }
  }
}
