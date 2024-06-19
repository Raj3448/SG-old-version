import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/routes/routes.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:uni_links/uni_links.dart';

class UniService {
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
      uniHandler(uri);
    }, onError: (Object err) {
      print('Failed to initialize deep links: $err');
    });
  }

  static void uniHandler(Uri? uri) {
    if (uri == null || uri.path.isEmpty) return;

    final redirectRouteName = uri.path;

    rootNavigatorKey.currentContext?.pushNamed(
      RoutesConstants.initialRoute,
      extra: {'redirectRouteName': redirectRouteName},
    );
  }
}
