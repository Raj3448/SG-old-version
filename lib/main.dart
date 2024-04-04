// ignore_for_file: unnecessary_lambdas

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/app/app.dart';
import 'package:silver_genie/core/env.dart';

import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/login-signup/store/login_store.dart';
import 'package:silver_genie/feature/main/store/main_store.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/onboarding/store/onboarding_store.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';
import 'package:silver_genie/firebase_options.dart';

void main() async {
  await runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();
      // Retain native splash screen until Dart is ready
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      GetIt.instance.registerLazySingleton(
        () => HttpClient(baseOptions: BaseOptions(baseUrl: Env.serverUrl)),
      );
      GetIt.instance.registerLazySingleton(() => MainStore());
      GetIt.instance.registerLazySingleton(() => MembersStore());
      GetIt.instance.registerLazySingleton(() => LoginStore());
      GetIt.instance.registerLazySingleton(() => OnboardingStore());
      GetIt.instance.registerLazySingleton(() => UserDetailStore());
      if (!kIsWeb) {
        if (kDebugMode) {
          await FirebaseCrashlytics.instance
              .setCrashlyticsCollectionEnabled(false);
        } else {
          await FirebaseCrashlytics.instance
              .setCrashlyticsCollectionEnabled(true);
        }
      }
      if (kDebugMode) {
        await FirebasePerformance.instance
            .setPerformanceCollectionEnabled(false);
      }
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      ErrorWidget.builder = (FlutterErrorDetails error) {
        Zone.current.handleUncaughtError(error.exception, error.stack!);
        return ErrorWidget(error.exception);
      };

      runApp(
        EasyLocalization(
          supportedLocales: const [Locale('en', 'US'), Locale('hi', 'IN')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en', 'US'),
          child: const MyApp(),
        ),
      );
      FlutterNativeSplash.remove(); // Now remove splash screen
    },
    (exception, stackTrace) {
      FirebaseCrashlytics.instance.recordError(exception, stackTrace);
    },
  );
}
