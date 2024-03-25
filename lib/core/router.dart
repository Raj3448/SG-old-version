import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/feature/login-signup/login_page.dart';
import 'package:silver_genie/feature/main/main_screen.dart';
import 'package:silver_genie/feature/onboarding/onboarding_screen.dart';
import 'package:silver_genie/feature/onboarding/store/onboarding_store.dart';

import 'package:silver_genie/home_page.dart';

final store = GetIt.I<OnboardingStore>();

GoRouter appRouter() => GoRouter(
      debugLogDiagnostics: kDebugMode,
      initialLocation: '/login',
      routes: <GoRoute>[
        GoRoute(
          path: '/login',
          name: LoginPage.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return Observer(
              builder: (context) {
                return store.showOnboarding
                    ? const OnboardingScreen()
                    : const MainScreen();
              },
            );
          },
        ),
        GoRoute(
          path: '/main',
          name: MainScreen.routeName,
          builder: (BuildContext context, GoRouterState state) =>
              const LoginPage(),
        ),
        GoRoute(
          path: '/loginEmail',
          name: LoginPageEmail.routeName,
          builder: (BuildContext context, GoRouterState state) =>
              const LoginPageEmail(),
        ),
        GoRoute(
          path: '/signup',
          name: SignUpScreen.routeName,
          builder: (BuildContext context, GoRouterState state) =>
              const SignUpScreen(),
        ),
        GoRoute(
          path: '/otp_screen',
          name: OTPScreen.routeName,
          builder: (BuildContext context, GoRouterState state) =>
              const OTPScreen(),
        ),
      ],
      observers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
    );
