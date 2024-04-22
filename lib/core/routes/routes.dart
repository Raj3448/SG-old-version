import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/feature/bookings/bookings_screen.dart';
import 'package:silver_genie/feature/emergency_services/emergency_services.dart';
import 'package:silver_genie/feature/home/home_screen.dart';
import 'package:silver_genie/feature/login-signup/login_page.dart';
import 'package:silver_genie/feature/login-signup/otp_screen.dart';
import 'package:silver_genie/feature/login-signup/signup_page.dart';
import 'package:silver_genie/feature/main/main_screen.dart';
import 'package:silver_genie/feature/main/repo/main_repo.dart';
import 'package:silver_genie/feature/members/screens/add_edit_family_member_screen.dart';
import 'package:silver_genie/feature/members/screens/epr_phr_view_screen.dart';
import 'package:silver_genie/feature/members/screens/member_details_screen.dart';
import 'package:silver_genie/feature/members/screens/members_screen.dart';
import 'package:silver_genie/feature/onboarding/onboarding_screen.dart';
import 'package:silver_genie/feature/onboarding/store/onboarding_store.dart';
import 'package:silver_genie/feature/services/screens/book_service_screen.dart';
import 'package:silver_genie/feature/services/screens/booking_details_screen.dart';
import 'package:silver_genie/feature/services/screens/payment_screen.dart';
import 'package:silver_genie/feature/services/screens/service_details_screen.dart';
import 'package:silver_genie/feature/services/screens/services_screen.dart';
import 'package:silver_genie/feature/services/services_subcare_screen.dart';
import 'package:silver_genie/feature/subscription/screens/subscriptions_screen.dart';
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
      pageBuilder: (context, state) {
        return const MaterialPage(child: MainScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.loginRoute,
      pageBuilder: (context, state) {
        return const MaterialPage(child: LoginPage());
      },
    ),
    GoRoute(
      path: RoutesConstants.signUpRoute,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SignUpScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.otpRoute,
      pageBuilder: (context, state) {
        return const MaterialPage(child: OTPScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.homeRoute,
      pageBuilder: (context, state) {
        return MaterialPage(child: HomeScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.userProfileRoute,
      pageBuilder: (context, state) {
        return const MaterialPage(child: UserProfile());
      },
    ),
    GoRoute(
      path: RoutesConstants.emergencyServiceScreen,
      pageBuilder: (context, state) {
        return const MaterialPage(child: EmergencyServices());
      },
    ),
    GoRoute(
      path: RoutesConstants.subscriptionsScreen,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SubscriptionsScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.subscriptionsScreen,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SubscriptionsScreen());
      },
    ),
    GoRoute(
      path: '/servicesCareScreen/:pageTitle',
      name: RoutesConstants.servicesCareScreen,
      pageBuilder: (context, state) {
        final pageTitle = state.pathParameters['pageTitle'];
        return MaterialPage(
          child: ServicesCareScreen(pageTitle: pageTitle!),
        );
      },
    ),
    GoRoute(
      path: RoutesConstants.serviceRoute,
      pageBuilder: (context, state) {
        return const MaterialPage(child: ServicesScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.bookingsRoute,
      pageBuilder: (context, state) {
        return const MaterialPage(child: BookingsScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.membersRoute,
      pageBuilder: (context, state) {
        return MaterialPage(
          child: MembersScreen(
            membersService: MockMemberService(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/addEditFamilyMember/:edit',
      name: RoutesConstants.addEditFamilyMemberRoute,
      pageBuilder: (context, state) {
        final edit = state.pathParameters['edit']!.toLowerCase() == 'true';
        return MaterialPage(child: AddEditFamilyMemberScreen(edit: edit));
      },
    ),
    GoRoute(
      path: RoutesConstants.eprPhrRoute,
      pageBuilder: (context, state) {
        return MaterialPage(child: EPRPHRViewScreen());
      },
    ),
    GoRoute(
      path:
          '/memberDetails/:name/:age/:gender/:relation/:mobileNo/:address/:hasCareSub',
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
    GoRoute(
      path:
          '/serviceDetailsScreen/:imgPath/:name/:yoe/:type/:docInfo/:hospital/:charges',
      name: RoutesConstants.serviceDetailsScreen,
      pageBuilder: (context, state) {
        return MaterialPage(
          child: ServiceDetailsScreen(
            imgPath: state.pathParameters['imgPath']!,
            name: state.pathParameters['name']!,
            yoe: state.pathParameters['yoe']!,
            type: state.pathParameters['type']!,
            docInfo: state.pathParameters['docInfo']!,
            hospital: state.pathParameters['hospital']!,
            charges: state.pathParameters['charges']!,
          ),
        );
      },
    ),
    GoRoute(
      path: RoutesConstants.bookServiceScreen,
      pageBuilder: (context, state) {
        return const MaterialPage(child: BookServiceScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.paymentScreen,
      pageBuilder: (context, state) {
        return const MaterialPage(child: PaymentScreen());
      },
    ),
    GoRoute(
      path: RoutesConstants.bookingDetailsScreen,
      pageBuilder: (context, state) {
        return const MaterialPage(child: BookingDetailsScreen());
      },
    ),
  ],
);
