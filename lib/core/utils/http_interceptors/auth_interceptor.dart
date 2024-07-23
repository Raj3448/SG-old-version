import 'package:dio/dio.dart';
import 'package:silver_genie/core/utils/token_manager.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);
  final TokenManager _tokenStorage;
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // TODO(You): Put the paths you want the interceptor to ignore
    if (!options.path.contains('/login') ||
        !options.path.contains('/register-complete') ||
        !options.path.contains('/verify-otp')) {
      // TODO(You): Fetch your access token and plug it in
      final token = await _tokenStorage.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
