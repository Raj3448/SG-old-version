import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/feature/login-signup/login_page.dart';
import 'package:silver_genie/feature/login-signup/login_page_email.dart';
import 'package:silver_genie/feature/login-signup/otp_screen.dart';
import 'package:silver_genie/feature/login-signup/signup_page.dart';



GoRouter appRouter() => GoRouter(
      debugLogDiagnostics: kDebugMode,
      initialLocation: '/login',
      routes: <GoRoute>[
        GoRoute(
          path: '/login',
          name: LoginPage.routeName,
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
