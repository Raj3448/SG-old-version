import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/routes/routes.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/utils/token_manager.dart';
import 'package:uni_links/uni_links.dart';

class UniService {
  // static String _code = '';
  // static String get code => _code;
  // static bool get hascode => _code.isNotEmpty;

  // static void reset() => _code = '';
  static Future<void> initUniLinks() async {
    try {
      final Uri? uri = await getInitialUri();
      uniHandler(uri);
    } on PlatformException {
      print('platform exception');
    } on FormatException {
      print('formatexception');
    } catch (e) {
      print('Failed to initialize deep links: $e');
    }
    uriLinkStream.listen((Uri? uri) async {
      if (uri != null) {
        uniHandler(uri);
      }
    }, onError: (Object err) {
      print('Failed to initialize deep links: $err');
    });
  }

  static void uniHandler(Uri? uri) {
    if (uri == null || uri.path.isEmpty) return;

    if(_isValidUrlPath(uri.path)){
      final hasToken = GetIt.I<TokenManager>().hasToken();
      if (!hasToken) {
        rootNavigatorKey.currentContext?.pushNamed(RoutesConstants.loginRoute);
      } else {
        rootNavigatorKey.currentContext?.pushNamed(uri.path);
      }
    } else {
      rootNavigatorKey.currentContext?.pushNamed('/error');
    }
  }

}
bool _isValidUrlPath(String path) {
    final validPaths = [
      RoutesConstants.homeRoute,
      RoutesConstants.serviceRoute,
      RoutesConstants.notificationScreen,
      RoutesConstants.loginRoute,
      RoutesConstants.couplePlanPage,
      RoutesConstants.onboardingRoute,
      RoutesConstants.signUpRoute,
      RoutesConstants.geniePage,
      RoutesConstants.initialRoute
    ];
    return validPaths.contains(path);
}