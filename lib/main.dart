// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silver_genie/core/app/app.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/payment/payment_services.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/core/utils/token_manager.dart';
import 'package:silver_genie/feature/auth/auth_store.dart';
import 'package:silver_genie/feature/bookings/services/booking_service.dart';
import 'package:silver_genie/feature/bookings/store/booking_service_store.dart';
import 'package:silver_genie/feature/genie/services/product_listing_services.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';
import 'package:silver_genie/feature/home/repository/local/home_page_details.dart';
import 'package:silver_genie/feature/home/services/home_services.dart';
import 'package:silver_genie/feature/home/store/home_store.dart';
import 'package:silver_genie/feature/login-signup/services/auth_service.dart';
import 'package:silver_genie/feature/login-signup/store/login_store.dart';
import 'package:silver_genie/feature/login-signup/store/signup_store.dart';
import 'package:silver_genie/feature/login-signup/store/verify_otp_store.dart';
import 'package:silver_genie/feature/members/repo/member_service.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/notification/services/fcm_notification_manager.dart';
import 'package:silver_genie/feature/notification/services/notification_service.dart';
import 'package:silver_genie/feature/notification/store/notification_store.dart';
import 'package:silver_genie/feature/onboarding/store/onboarding_store.dart';
import 'package:silver_genie/feature/user_profile/repository/local/user_details_cache.dart';
import 'package:silver_genie/feature/user_profile/services/user_services.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';
import 'package:silver_genie/setup_hive_boxes.dart';

void main() async {
  await runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();
      await Firebase.initializeApp();
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      if (kDebugMode) {
        print('Crashlytics enabled in Debug Mode');
      }

      FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
      await Hive.initFlutter();
      await setupHiveBox();
      // Initialize SharedPreferences asynchronously
      GetIt.instance.registerSingletonAsync<SharedPreferences>(
        SharedPreferences.getInstance,
      );
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: AppColors.white,
          systemNavigationBarColor: AppColors.white,
          systemNavigationBarDividerColor: AppColors.white,
        ),
      );
      // Wait for all asynchronous singletons (like SharedPreferences) to be ready
      await GetIt.instance.allReady();

      GetIt.instance.registerSingleton(
        OnboardingStore(preferences: GetIt.instance.get<SharedPreferences>()),
      );

      GetIt.instance.registerSingleton<TokenManager>(TokenManager());
      GetIt.instance.registerSingleton<UserDetailsCache>(UserDetailsCache());
      GetIt.instance.registerLazySingleton(HomePageComponentDetailscache.new);
      GetIt.instance.registerSingleton<AuthStore>(
        AuthStore(
          tokenManager: GetIt.instance.get<TokenManager>(),
          userCache: GetIt.instance.get<UserDetailsCache>(),
        )..refresh(),
      );

      GetIt.instance.registerLazySingleton<HttpClient>(
        () => HttpClient(baseOptions: BaseOptions(baseUrl: Env.serverUrl)),
      );

      GetIt.instance.registerLazySingleton(
        () => AuthService(
          httpClient: GetIt.instance.get<HttpClient>(),
          userDetailsCache: GetIt.instance.get<UserDetailsCache>(),
          tokenManager: GetIt.instance.get<TokenManager>(),
        ),
      );
      GetIt.instance.registerLazySingleton(
        () => HomeService(
          httpClient: GetIt.I<HttpClient>(),
          homePageComponentDetailscache:
              GetIt.I<HomePageComponentDetailscache>(),
        ),
      );
      GetIt.instance.registerLazySingleton(
        () => MemberServices(
          GetIt.instance.get<HttpClient>(),
        ),
      );
      GetIt.instance.registerLazySingleton(
        () => MembersStore(
          GetIt.instance.get<MemberServices>(),
        ),
      );
      GetIt.instance.registerLazySingleton(
        () => LoginStore(
          GetIt.instance.get<AuthService>(),
        ),
      );
      GetIt.instance.registerLazySingleton(
        () => VerityOtpStore(
          GetIt.instance.get<AuthService>(),
        ),
      );

      GetIt.instance.registerLazySingleton(
        () => SignupStore(
          GetIt.instance.get<AuthService>(),
        ),
      );
      GetIt.instance.registerLazySingleton(
        () => UserDetailServices(
          GetIt.I<UserDetailsCache>(),
          GetIt.instance.get<HttpClient>(),
        ),
      );
      GetIt.instance.registerLazySingleton(
        () =>
            HomeStore(homeServices: GetIt.I<HomeService>())..initHomePageData(),
      );
      GetIt.instance.registerLazySingleton(
        () => UserDetailStore(
          GetIt.I<UserDetailServices>(),
          GetIt.I<UserDetailsCache>(),
        ),
      );
      GetIt.instance.registerLazySingleton(
        () => NotificationServices(httpClient: GetIt.I<HttpClient>()),
      );
      GetIt.instance.registerLazySingleton(
        () => NotificationStore(GetIt.I<NotificationServices>()),
      );
      GetIt.instance.registerLazySingleton(
        () => ProductListingServices(httpClient: GetIt.I<HttpClient>()),
      );
      GetIt.instance.registerLazySingleton(
        () => ProductListingStore(
          productListingService: GetIt.I<ProductListingServices>(),
        )..initGetProductBasicDetails(),
      );
      GetIt.instance.registerLazySingleton(
        () => BookingService(httpClient: GetIt.I<HttpClient>()),
      );
      GetIt.instance.registerLazySingleton(
        () => BookingServiceStore(ibookingService: GetIt.I<BookingService>()),
      );
      GetIt.instance.registerLazySingleton(
        () => PaymentService(
          httpClient: GetIt.I<HttpClient>(),
          productListingStore: GetIt.I<ProductListingStore>(),
        ),
      );
      await FlutterDownloader.initialize(
        debug: true,
        ignoreSsl: true,
      );
      // Retain native splash screen until Dart is ready
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      if (!kIsWeb) {
        if (kDebugMode) {
          await FirebaseCrashlytics.instance
              .setCrashlyticsCollectionEnabled(true);
        } else {
          await FirebaseCrashlytics.instance
              .setCrashlyticsCollectionEnabled(true);
        }
      }
      if (kDebugMode) {
        await FirebasePerformance.instance
            .setPerformanceCollectionEnabled(true);
      }

      ErrorWidget.builder = (FlutterErrorDetails error) {
        Zone.current.handleUncaughtError(error.exception, error.stack!);
        return ErrorWidget(error.exception);
      };
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          statusBarColor: AppColors.grayscale100,
          systemNavigationBarContrastEnforced: true,
          systemStatusBarContrastEnforced: true,
        ),
      );
      runApp(
        EasyLocalization(
          supportedLocales: const [Locale('en', 'US'), Locale('hi', 'IN')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en', 'US'),
          child: const MyApp(),
        ),
      );
      FlutterNativeSplash.remove();
    },
    (exception, stackTrace) {
      FirebaseCrashlytics.instance.recordError(exception, stackTrace, fatal: true);
    },
  );
}
