import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/feature/bookings/bookings_screen.dart';
import 'package:silver_genie/feature/home/home_screen.dart';
import 'package:silver_genie/feature/login-signup/login_page.dart';
import 'package:silver_genie/feature/login-signup/otp_screen.dart';
import 'package:silver_genie/feature/login-signup/signup_page.dart';
import 'package:silver_genie/feature/main/main_screen.dart';
import 'package:silver_genie/feature/members/screens/add_edit_family_member_screen.dart';
import 'package:silver_genie/feature/members/screens/epr_phr_view_screen.dart';
import 'package:silver_genie/feature/members/screens/member_details_screen.dart';
import 'package:silver_genie/feature/members/screens/members_screen.dart';
import 'package:silver_genie/feature/onboarding/onboarding_screen.dart';
import 'package:silver_genie/feature/onboarding/store/onboarding_store.dart';
import 'package:silver_genie/feature/services/services_screen.dart';
import 'package:silver_genie/feature/user_profile/user_profile.dart';

final store = GetIt.I<OnboardingStore>();

final GoRouter routes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: RoutesConstants.initialRoute,
      builder: (context, state) {
        return Observer(
          builder: (context) {
            return store.showOnboarding
                ? const OnboardingScreen()
                : const LoginPage();
          },
        );
      },
    ),
    GoRoute(
      path: RoutesConstants.mainRoute,
      name: 'main',
      pageBuilder: (context, state) {
        return const MaterialPage(child: MainScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.loginRoute,
      name: 'login',
      pageBuilder: (context, state) {
        return const MaterialPage(child: LoginPage());
      },
    ),
    GoRoute(
      path: RoutesConstants.signUpRoute,
      name: 'signUp',
      pageBuilder: (context, state) {
        return const MaterialPage(child: SignUpScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.otpRoute,
      name: 'otp',
      pageBuilder: (context, state) {
        return const MaterialPage(child: OTPScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.homeRoute,
      name: 'home',
      pageBuilder: (context, state) {
        return const MaterialPage(child: HomeScreen());
      },
    ),
    GoRoute(
      path: '/userProfileScreen',
      name: RoutesConstants.userProfileScreen,
      pageBuilder: (context, state) {
        return const MaterialPage(child: UserProfile());
      },
    ),
    GoRoute(
      path: RoutesConstants.serviceRoute,
      name: 'service',
      pageBuilder: (context, state) {
        return const MaterialPage(child: ServicesScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.bookingsRoute,
      name: 'bookings',
      pageBuilder: (context, state) {
        return const MaterialPage(child: BookingsScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.membersRoute,
      name: 'members',
      pageBuilder: (context, state) {
        return const MaterialPage(child: MembersScreen());
      },
    ),
    GoRoute(
      path: '/addFamilyMember/:edit',
      name: RoutesConstants.addEditFamilyMemberRoute,
      pageBuilder: (context, state) {
        final edit = state.pathParameters['edit']!.toLowerCase() == 'true';
        return MaterialPage(child: AddEditFamilyMemberScreen(edit: edit));
      },
    ),
    GoRoute(
      path: RoutesConstants.eprPhrRoute,
      name: 'eprPhr',
      pageBuilder: (context, state) {
        return const MaterialPage(child: EPRPHRViewScreen());
      },
    ),
    GoRoute(
      path:
          '/members/:name/:age/:gender/:relation/:mobileNo/:address/:hasCareSub',
      name: RoutesConstants.memberDetailsRoute,
      pageBuilder: (context, state) {
        final hasCareSub =
            state.pathParameters['hasCareSub']!.toLowerCase() == 'true';
        return MaterialPage(
          child: MemberDetailsScreen(
            name: state.pathParameters['name']!,
            age: state.pathParameters['age']!,
            gender: state.pathParameters['gender']!,
            relation: state.pathParameters['relation']!,
            mobileNo: state.pathParameters['mobileNo']!,
            address: state.pathParameters['address']!,
            hasCareSub: hasCareSub,
          ),
        );
      },
    ),
  ],
);
