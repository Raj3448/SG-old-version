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
import 'package:silver_genie/feature/genie/screens/couple_plan_page.dart';
import 'package:silver_genie/feature/genie/screens/genie_page.dart';
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
import 'package:silver_genie/feature/services/screens/book_service_screen.dart';
import 'package:silver_genie/feature/services/screens/booking_details_screen.dart';
import 'package:silver_genie/feature/services/screens/payment_screen.dart';
import 'package:silver_genie/feature/services/screens/service_details_screen.dart';
import 'package:silver_genie/feature/services/screens/services_screen.dart';
import 'package:silver_genie/feature/services/screens/services_subcare_page.dart';
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
        ));
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/servicesCareScreen/:pageTitle/:isConvenience',
      name: RoutesConstants.servicesCareScreen,
      pageBuilder: (context, state) {
        final pageTitle = state.pathParameters['pageTitle'] ?? 'Care';
        final isConvenience =
            state.pathParameters['isConvenience'].toString().toLowerCase();
        return MaterialPage(
          child: ServicesCareScreen(
            pagetitle: pageTitle,
            isConvenience: bool.parse(isConvenience),
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/addEditFamilyMember/:edit/:isSelf',
      name: RoutesConstants.addEditFamilyMemberRoute,
      pageBuilder: (context, state) {
        final edit = state.pathParameters['edit']!.toLowerCase();
        final isSelf = state.pathParameters['isSelf']!.toLowerCase();
        return MaterialPage(
          child: AddEditFamilyMemberScreen(
            edit: bool.parse(edit),
            isSelf: bool.parse(isSelf),
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
      path: '/SGSubcscriptionPage',
      name: RoutesConstants.SGSubcscriptionPage,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SGSubcscriptionPage());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/couplePlanPage/:pageTitle',
      name: RoutesConstants.couplePlanPage,
      pageBuilder: (context, state) {
        final pageTitle = state.pathParameters['pageTitle'] ?? 'Genie';
        return MaterialPage(
          child: CouplePlanPage(
            pageTitle: pageTitle,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/geniePage/:pageTitle/:defination/:headline',
      name: RoutesConstants.geniePage,
      pageBuilder: (context, state) {
        final pageTitle = state.pathParameters['pageTitle'] ?? '';
        final defination = state.pathParameters['defination'] ?? '';
        final headline = state.pathParameters['headline'] ?? '';
        // final subscriptionTypeString = state.pathParameters['subscriptionType'] ?? '';

        // final SubscriptionsType subscriptionType = SubscriptionsType.values.firstWhereOrNull(
        //   (e) => e.toString().split('.').last == subscriptionTypeString,
        // ) ?? SubscriptionsType.companion;

        return MaterialPage(
          child: GeniePage(
            pageTitle: pageTitle,
            headline: headline,
            definition: defination,
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
      parentNavigatorKey: rootNavigatorKey,
      path: RoutesConstants.bookServiceScreen,
      pageBuilder: (context, state) {
        return MaterialPage(child: BookServiceScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/bookingServiceStatusDetailsPage/:bookingServiceStatus',
      name: RoutesConstants.bookingServiceStatusDetailsPage,
      pageBuilder: (context, state) {
        final bookingServiceStatusString =
            state.pathParameters['bookingServiceStatus'];
        var bookingServiceStatus = BookingServiceStatus.values
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
