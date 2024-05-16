import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:firebase_performance_dio/firebase_performance_dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:silver_genie/core/utils/http_interceptors/auth_interceptor.dart';
import 'package:silver_genie/core/utils/http_interceptors/error_interceptor.dart';
import 'package:silver_genie/core/utils/http_interceptors/user_agent_interceptor.dart';
import 'package:silver_genie/core/utils/token_manager.dart';

class HttpClient with DioMixin implements Dio {
  HttpClient({BaseOptions? baseOptions}) {
    options = (baseOptions ?? BaseOptions()).copyWith(
      validateStatus: (int? status) {
        return status != null && status >= 200 && status < 400;
      },
    );
    // httpClientAdapter = Http2Adapter(
    //   ConnectionManager(
    //     idleTimeout: const Duration(seconds: 10),
    //     onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
    //   ),
    // );
    httpClientAdapter = DefaultHttpClientAdapter();
    final TokenManager tokenStorage = GetIt.I<TokenManager>();
    interceptors.addAll([
      ErrorInterceptor(),
      AuthInterceptor(tokenStorage),
      UserAgentInterceptor(),
      DioFirebasePerformanceInterceptor(),

      /*CookieManager(PersistCookieJar(
        ignoreExpires: true,
        storage: FileStorage("${GetIt.I<Directory>().path}/.cookies/"),
      )),*/
    ]);

    if (kDebugMode) {
      interceptors.add(
        PrettyDioLogger(
          responseHeader: true,
          responseBody: false,
          request: false,
        ),
      );
    }
    // _dio.addSentry();
  }

  static CacheOptions defaultCacheOptions = CacheOptions(
    // A default store is required for interceptor.
    store: MemCacheStore(),

    // Optional. Returns a cached response on error but for statuses 401 & 403.
    // hitCacheOnErrorExcept: [401, 403, 500],
    // Optional. Overrides HTTPs directive to delete entry past this duration.
    maxStale: const Duration(hours: 1),
  );
}
