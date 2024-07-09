// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/utils/token_manager.dart';
import 'package:silver_genie/core/widgets/booking_service_listile_component.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/feature/auth/auth_store.dart';
import 'package:silver_genie/feature/book_services/model/payment_status_model.dart';
import 'package:silver_genie/feature/book_services/model/service_tracking_response.dart';
import 'package:silver_genie/feature/book_services/screens/all_services_screen.dart';
import 'package:silver_genie/feature/book_services/screens/book_service_screen.dart';
import 'package:silver_genie/feature/book_services/screens/service_booking_payment_detail_screen.dart';
import 'package:silver_genie/feature/book_services/screens/payment_status_tracking_page.dart';
import 'package:silver_genie/feature/book_services/screens/service_details_screen.dart';
import 'package:silver_genie/feature/book_services/screens/service_payment_screen.dart';
import 'package:silver_genie/feature/book_services/screens/services_screen.dart';
import 'package:silver_genie/feature/bookings/booking_details_screen.dart';
import 'package:silver_genie/feature/bookings/bookings_screen.dart';
import 'package:silver_genie/feature/bookings/service_booking_details_screen.dart';
import 'package:silver_genie/feature/emergency_services/emergency_services.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/screens/couple_plan_page.dart';
import 'package:silver_genie/feature/genie/screens/genie_page.dart';
import 'package:silver_genie/feature/genie/screens/subscription_details_screen.dart';
import 'package:silver_genie/feature/genie/screens/subscription_payment_screen.dart';
import 'package:silver_genie/feature/home/home_screen.dart';
import 'package:silver_genie/feature/home/store/home_store.dart';
import 'package:silver_genie/feature/login-signup/login_page.dart';
import 'package:silver_genie/feature/login-signup/otp_screen.dart';
import 'package:silver_genie/feature/login-signup/signup_page.dart';
import 'package:silver_genie/feature/login-signup/store/verify_otp_store.dart';
import 'package:silver_genie/feature/main/main_screen.dart';
import 'package:silver_genie/feature/members/screens/add_edit_family_member_screen.dart';
import 'package:silver_genie/feature/members/screens/epr_view_screen.dart';
import 'package:silver_genie/feature/members/screens/family_screen.dart';
import 'package:silver_genie/feature/members/screens/member_details_screen.dart';
import 'package:silver_genie/feature/members/screens/phr_pdf_view_page.dart';
import 'package:silver_genie/feature/notification/notification_screen.dart';
import 'package:silver_genie/feature/onboarding/onboarding_screen.dart';
import 'package:silver_genie/feature/onboarding/store/onboarding_store.dart';
import 'package:silver_genie/feature/screens/splashscreen.dart';
import 'package:silver_genie/feature/subscription/screens/sg_subscription_plan_page.dart';
import 'package:silver_genie/feature/subscription/screens/subscriptions_screen.dart';
import 'package:silver_genie/feature/user_profile/profile_details.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';
import 'package:silver_genie/feature/user_profile/user_profile.dart';

final store = GetIt.I<OnboardingStore>();
final authStore = GetIt.I<AuthStore>();
final homeStore = GetIt.I<HomeStore>();

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();
String? updateBotNavPageName;

final GoRouter routes = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    if (state.matchedLocation.startsWith('/login') ||
        state.matchedLocation.startsWith('/otp') ||
        state.matchedLocation.startsWith('/signup') ||
        state.matchedLocation.startsWith('/onboarding')) {
      resetAllCache();
      return null;
    }

    if (state.uri.path == '/') {
      return null;
    }
    final skipRedirect = bool.tryParse(
          state.uri.queryParameters['skipRootRedirectCheck'] ?? 'false',
        ) ??
        false;

    if (skipRedirect) {
      return null;
    }

    if (!homeStore.isHomepageDataLoaded ||
        store.showOnboarding ||
        !authStore.isAuthenticated ||
        !authStore.initialised) {
      final route = '/?redirectRouteName=${state.fullPath}';
      return route;
    }
    updateBotNavPageName = state.uri.path;
    return null;
  },
  routes: [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: RoutesConstants.initialRoute,
      name: RoutesConstants.initialRoute,
      redirect: (context, state) {
        final redirectRouteName =
            state.uri.queryParameters['redirectRouteName'];

        if (!homeStore.isHomepageDataLoaded) {
          return null;
        }

        if (store.showOnboarding) {
          return RoutesConstants.onboardingRoute;
        }

        if (!authStore.isAuthenticated) {
          return '${RoutesConstants.loginRoute}?redirectRouteName=${redirectRouteName ?? ''}';
        }

        if (!authStore.initialised) return null;

        if (redirectRouteName != null && redirectRouteName.isNotEmpty) {
          return redirectRouteName;
        }
        return RoutesConstants.homeRoute;
      },
      builder: (context, state) {
        final redirectRouteName =
            state.uri.queryParameters['redirectRouteName'];
        return SplashscreenWidget(redirectRouteName: redirectRouteName);
      },
    ),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state, child) {
        if (updateBotNavPageName != null) {
          final redirectByNotifyPageName = updateBotNavPageName;
          updateBotNavPageName = null;
          return MaterialPage(
            child: MainScreen(
              path: redirectByNotifyPageName!,
              child: child,
            ),
          );
        }
        return MaterialPage(
            child: MainScreen(
              path: state.fullPath ?? '',
              child: child,
            ),
          );
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
          name: RoutesConstants.familyRoute,
          path: '/family',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: FamilyScreen());
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
        final redirectRouteName =
            state.uri.queryParameters['redirectRouteName'];
        return MaterialPage(
          child: LoginPage(
            redirectRouteName: redirectRouteName,
          ),
        );
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
        final redirectRouteName = extraData?['redirectRouteName'] as String?;
        return MaterialPage(
          child: OTPScreen(
            isFromLoginPage: isFromLoginPage,
            email: email,
            phoneNumber: phoneNumber,
            redirectRouteName: redirectRouteName,
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
      path: '/couplePlanPage/:id/:pageTitle',
      name: RoutesConstants.couplePlanPage,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final pageTitle = state.pathParameters['pageTitle'] ?? 'Genie';
        final extraData = state.extra as Map<String, dynamic>?;
        final plansListJson = extraData?['plansList'] as String;
        final isUpgradable =
            bool.tryParse(extraData?['isUpgradable'].toString() ?? 'false') ??
                false;
        final planList = (jsonDecode(plansListJson) as List<dynamic>)
            .map((plan) => Price.fromJson(plan as Map<String, dynamic>))
            .toList();
        return MaterialPage(
          child: CouplePlanPage(
            id: id,
            pageTitle: pageTitle,
            planList: planList,
            isUpgradable: isUpgradable,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/geniePage/:pageTitle/:id/:isUpgradeable/:activeMemberId',
      name: RoutesConstants.geniePage,
      pageBuilder: (context, state) {
        final pageTitle = state.pathParameters['pageTitle'] ?? '';
        final id = state.pathParameters['id'] ?? '';
        final isUpgradeableString =
            state.pathParameters['isUpgradeable'] ?? 'false';
        final isUpgradable = isUpgradeableString.toLowerCase() == 'true';
        final activeMemberId = state.pathParameters['activeMemberId'] ?? '';

        return MaterialPage(
          child: GeniePage(
            pageTitle: pageTitle,
            id: id,
            isUpgradable: isUpgradable,
            activeMemberId: activeMemberId,
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
      path: '/serviceDetailsScreen/:id/:title/:productCode',
      name: RoutesConstants.serviceDetailsScreen,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return MaterialPage(
          child: ServiceDetailsScreen(
            id: id,
            title: state.pathParameters['title'] ?? '',
            productCode: state.pathParameters['productCode'] ?? '',
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/bookServiceScreen/:id/:productCode',
      name: RoutesConstants.bookServiceScreen,
      pageBuilder: (context, state) {
        final serviceId = state.pathParameters['id'].toString();
        final productCode = state.pathParameters['productCode'].toString();
        return MaterialPage(
          child: BookServiceScreen(
            id: serviceId,
            productCode: productCode,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/bookingServiceStatusDetailsPage/:bookingServiceStatus/:serviceId',
      name: RoutesConstants.bookingServiceStatusDetailsPage,
      pageBuilder: (context, state) {
        final bookingServiceStatusString =
            state.pathParameters['bookingServiceStatus'];
        final bookingServiceStatus = BookingServiceStatus.values
            .firstWhere((e) => e.toString() == bookingServiceStatusString);
        final serviceId = state.pathParameters['serviceId'] ?? '';
        return MaterialPage(
          child: ServiceBookingDetailsScreen(
            bookingServiceStatus: bookingServiceStatus,
            serviceId: serviceId,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/servicePaymentStatusTrackingPage/:id',
      name: RoutesConstants.servicePaymentStatusTrackingPage,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return MaterialPage(
          child: ServicePaymentStatusTrackingPage(
            id: id,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/bookingDetailsScreen/:id',
      name: RoutesConstants.bookingDetailsScreen,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'].toString();
        return MaterialPage(
          child: BookingDetailsScreen(
            id: id,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/paymentScreen',
      name: RoutesConstants.paymentScreen,
      pageBuilder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>?;
        final paymentStatusModel =
            extraData?['paymentStatusModel'] as ServicePaymentStatusModel?;
        final priceDetails = extraData?['priceDetails'] as PriceDetails?;
        final id = extraData?['id'] as String;
        return MaterialPage(
          child: ServicePaymentScreen(
            servicePaymentStatusModel: paymentStatusModel,
            priceDetails: priceDetails,
            id: id,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/serviceBookingPaymentDetailScreen',
      name: RoutesConstants.serviceBookingPaymentDetailScreen,
      pageBuilder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>?;
        final paymentDetails =
            extraData?['paymentDetails'] as ServiceTrackerResponse;
        return MaterialPage(
          child: ServiceBookingPaymentDetailScreen(
            paymentDetails: paymentDetails,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: RoutesConstants.profileDetails,
      pageBuilder: (context, state) {
        return const MaterialPage(child: ProfileDetails());
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/subscriDetailsScreen/:price/:subscriptionData/:isCouple',
      name: RoutesConstants.subscriptionDetailsScreen,
      pageBuilder: (context, state) {
        final isCoupleString = state.pathParameters['isCouple'] ?? 'false';
        final isCouple = isCoupleString.toLowerCase() == 'true';
        final subscriptionDataString =
            state.pathParameters['subscriptionData'] ?? '{}';
        final subscriptionDataMap =
            json.decode(subscriptionDataString) as Map<String, dynamic>;

        return MaterialPage(
          child: SubscriptionDetailsScreen(
            price: state.pathParameters['price'] ?? '',
            subscriptionData: SubscriptionData.fromJson(subscriptionDataMap),
            isCouple: isCouple,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/subscriptionPaymentScreen',
      name: RoutesConstants.subscriptionPaymentScreen,
      pageBuilder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>?;
        final subscriptionDetails =
            extraData?['subscriptionDetails'] as SubscriptionDetails?;
        final priceId = extraData?['priceId'] as String;
        final price = extraData?['price'] as String;
        return MaterialPage(
          child: SubscriptionPaymentScreen(
            subscriptionDetails: subscriptionDetails,
            priceId: priceId,
            price: price,
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

void resetAllCache() {
  if (GetIt.I<TokenManager>().hasToken()) {
    GetIt.I<AuthStore>().logout();
    GetIt.I<VerityOtpStore>().resetTimer();
  }
}
