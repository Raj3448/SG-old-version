import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/booking_service_listile_component.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/feature/auth/auth_store.dart';
import 'package:silver_genie/feature/bookings/booking_sevice_status_page.dart';
import 'package:silver_genie/feature/bookings/bookings_screen.dart';
import 'package:silver_genie/feature/emergency_services/emergency_services.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/screens/couple_plan_page.dart';
import 'package:silver_genie/feature/genie/screens/genie_page.dart';
import 'package:silver_genie/feature/genie/screens/subscription_details_screen.dart';
import 'package:silver_genie/feature/home/home_screen.dart';
import 'package:silver_genie/feature/home/store/home_store.dart';
import 'package:silver_genie/feature/login-signup/login_page.dart';
import 'package:silver_genie/feature/login-signup/otp_screen.dart';
import 'package:silver_genie/feature/login-signup/signup_page.dart';
import 'package:silver_genie/feature/main/main_screen.dart';
import 'package:silver_genie/feature/members/screens/add_edit_family_member_screen.dart';
import 'package:silver_genie/feature/members/screens/epr_view_screen.dart';
import 'package:silver_genie/feature/members/screens/member_details_screen.dart';
import 'package:silver_genie/feature/members/screens/members_screen.dart';
import 'package:silver_genie/feature/members/screens/phr_pdf_view_page.dart';
import 'package:silver_genie/feature/notification/notification_screen.dart';
import 'package:silver_genie/feature/onboarding/onboarding_screen.dart';
import 'package:silver_genie/feature/onboarding/store/onboarding_store.dart';
import 'package:silver_genie/feature/screens/splashscreen.dart';
import 'package:silver_genie/feature/book_services/screens/all_services_screen.dart';
import 'package:silver_genie/feature/book_services/screens/book_service_screen.dart';
import 'package:silver_genie/feature/book_services/screens/booking_details_screen.dart';
import 'package:silver_genie/feature/book_services/screens/payment_screen.dart';
import 'package:silver_genie/feature/book_services/screens/service_details_screen.dart';
import 'package:silver_genie/feature/book_services/screens/services_screen.dart';
import 'package:silver_genie/feature/subscription/screens/sg_subscription_plan_page.dart';
import 'package:silver_genie/feature/subscription/screens/subscriptions_screen.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';
import 'package:silver_genie/feature/user_profile/user_profile.dart';

final store = GetIt.I<OnboardingStore>();
final authStore = GetIt.I<AuthStore>();
final homeStore = GetIt.I<HomeStore>();

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter routes = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: RoutesConstants.initialRoute,
      name: RoutesConstants.initialRoute,
      redirect: (context, state) {
        if (!homeStore.isHomepageDataLoaded) {
          return null;
        }

        if (store.showOnboarding) {
          return RoutesConstants.onboardingRoute;
        }
        if (authStore.isAuthenticated) {
          return RoutesConstants.homeRoute;
        }
        if (!authStore.initialised) return null;

        return RoutesConstants.loginRoute;
      },
      builder: (context, state) {
        /// Add splash screen here
        return const SplashscreenWidget();
      },
    ),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state, child) {
        return MaterialPage(child: MainScreen(child: child));
      },
      routes: <RouteBase>[
        GoRoute(
          name: RoutesConstants.homeRoute,
          path: '/home',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: HomeScreen());
          },
        ),
        GoRoute(
          name: RoutesConstants.serviceRoute,
          path: '/service',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: ServicesScreen());
          },
        ),
        GoRoute(
          name: RoutesConstants.bookingsRoute,
          path: '/bookings',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: BookingsScreen());
          },
        ),
        GoRoute(
          name: RoutesConstants.membersRoute,
          path: '/members',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: MembersScreen());
          },
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: RoutesConstants.onboardingRoute,
      name: '/onboarding',
      pageBuilder: (context, state) {
        return const MaterialPage(child: OnboardingScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: RoutesConstants.loginRoute,
      name: RoutesConstants.loginRoute,
      pageBuilder: (context, state) {
        return const MaterialPage(child: LoginPage());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: RoutesConstants.signUpRoute,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SignUpScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/otp',
      name: RoutesConstants.otpRoute,
      pageBuilder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>?;
        final email = extraData?['email'] as String?;
        final phoneNumber = extraData?['phoneNumber'] as String?;
        final isFromLoginPage = extraData?['isFromLoginPage'] == 'true';
        return MaterialPage(
          child: OTPScreen(
            isFromLoginPage: isFromLoginPage,
            email: email,
            phoneNumber: phoneNumber,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/userProfile',
      name: RoutesConstants.userProfileRoute,
      pageBuilder: (context, state) {
        return MaterialPage(
          child: UserProfile(
            userDetailStore: GetIt.I<UserDetailStore>(),
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: RoutesConstants.emergencyServiceScreen,
      pageBuilder: (context, state) {
        return const MaterialPage(child: EmergencyServices());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/notificationScreen',
      name: RoutesConstants.notificationScreen,
      pageBuilder: (context, state) {
        return const MaterialPage(child: NotificationScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/subscriptionsScreen',
      name: RoutesConstants.subscriptionsScreen,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SubscriptionsScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: RoutesConstants.subscriptionsScreen,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SubscriptionsScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/eprPhrPdfViewPage/:memberPhrId',
      name: RoutesConstants.phrPdfViewPage,
      pageBuilder: (context, state) {
        final memberPhrId = state.pathParameters['memberPhrId'].toString();
        return MaterialPage(
          child: PhrPdfViewPage(
            memberPhrId: memberPhrId,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/allServicesScreen/:isConvenience/:isHealthCare/:isHomeCare',
      name: RoutesConstants.allServicesScreen,
      pageBuilder: (context, state) {
        final isConvenience =
            state.pathParameters['isConvenience'].toString().toLowerCase();
        final isHealthCare =
            state.pathParameters['isHealthCare'].toString().toLowerCase();
        final isHomeCare =
            state.pathParameters['isHomeCare'].toString().toLowerCase();
        return MaterialPage(
          child: AllServicesScreen(
            isConvenience: bool.tryParse(isConvenience) ?? false,
            isHealthCare: bool.tryParse(isHealthCare) ?? false,
            isHomeCare: bool.tryParse(isHomeCare) ?? false,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/addEditFamilyMember/:edit/:isSelf',
      name: RoutesConstants.addEditFamilyMemberRoute,
      pageBuilder: (context, state) {
        final edit = state.pathParameters['edit']?.toLowerCase();
        final isSelf = state.pathParameters['isSelf']?.toLowerCase();
        return MaterialPage(
          child: AddEditFamilyMemberScreen(
            edit: bool.tryParse(edit ?? 'false') ?? false,
            isSelf: bool.tryParse(isSelf ?? 'false') ?? false,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/eprPhr/:memberId',
      name: RoutesConstants.eprRoute,
      pageBuilder: (context, state) {
        final memberId = state.pathParameters['memberId'];

        return MaterialPage(
          child: EPRViewScreen(
            memberId: memberId ?? '',
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/sgSubscriptionPage',
      name: RoutesConstants.sgSubscriptionPage,
      pageBuilder: (context, state) {
        return const MaterialPage(child: sgSubscriptionPage());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/couplePlanPage/:pageTitle',
      name: RoutesConstants.couplePlanPage,
      pageBuilder: (context, state) {
        final pageTitle = state.pathParameters['pageTitle'] ?? 'Genie';
        final extraData = state.extra as Map<String, dynamic>?;
        final plansListJson = extraData?['plansList'] as String;
        final planList = (jsonDecode(plansListJson) as List<dynamic>)
            .map((plan) => Price.fromJson(plan as Map<String, dynamic>))
            .toList();
        return MaterialPage(
          child: CouplePlanPage(
            pageTitle: pageTitle,
            planList: planList,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/geniePage/:pageTitle/:id/:isUpgradeable',
      name: RoutesConstants.geniePage,
      pageBuilder: (context, state) {
        final pageTitle = state.pathParameters['pageTitle'] ?? '';
        final id = state.pathParameters['id'] ?? '';
        final isUpgradeableString =
            state.pathParameters['isUpgradeable'] ?? 'false';
        final isUpgradeable = isUpgradeableString.toLowerCase() == 'true';

        return MaterialPage(
          child: GeniePage(
            pageTitle: pageTitle,
            id: id,
            isUpgradeable: isUpgradeable,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/memberDetails/:memberId',
      name: RoutesConstants.memberDetailsRoute,
      pageBuilder: (context, state) {
        return MaterialPage(
          child: MemberDetailsScreen(
            memberId: int.parse(state.pathParameters['memberId']!),
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/serviceDetailsScreen/:id/:title',
      name: RoutesConstants.serviceDetailsScreen,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return MaterialPage(
          child: ServiceDetailsScreen(
            id: id,
            title: state.pathParameters['title'] ?? '',
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/bookServiceScreen/:id',
      name: RoutesConstants.bookServiceScreen,
      pageBuilder: (context, state) {
        final serviceId = state.pathParameters['id'].toString();
        return MaterialPage(
          child: BookServiceScreen(
            id: serviceId,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/bookingServiceStatusDetailsPage/:bookingServiceStatus',
      name: RoutesConstants.bookingServiceStatusDetailsPage,
      pageBuilder: (context, state) {
        final bookingServiceStatusString =
            state.pathParameters['bookingServiceStatus'];
        final bookingServiceStatus = BookingServiceStatus.values
            .firstWhere((e) => e.toString() == bookingServiceStatusString);
        return MaterialPage(
          child: BookingSeviceStatusPage(
            bookingServiceStatus: bookingServiceStatus,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/paymentScreen',
      name: RoutesConstants.paymentScreen,
      pageBuilder: (context, state) {
        return const MaterialPage(child: PaymentScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: RoutesConstants.bookingDetailsScreen,
      pageBuilder: (context, state) {
        return const MaterialPage(child: BookingDetailsScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/subscriDetailsScreen/:price',
      name: RoutesConstants.subscriptionDetailsScreen,
      pageBuilder: (context, state) {
        return MaterialPage(
          child: SubscriptionDetailsScreen(
            price: state.pathParameters['price'] ?? '',
          ),
        );
      },
    ),
  ],
  errorPageBuilder: (_, __) => const MaterialPage(
    child: SafeArea(
      child: Scaffold(
        body: ErrorStateComponent(
          errorType: ErrorType.pageNotFound,
        ),
      ),
    ),
  ),
);
