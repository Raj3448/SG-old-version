import 'package:dio/dio.dart';
import 'package:silver_genie/core/utils/token_manager.dart';

class AuthInterceptor extends Interceptor {
  final TokenManager _tokenStorage;

  AuthInterceptor(this._tokenStorage);
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO(You): Put the paths you want the interceptor to ignore
    if (!options.path.contains('/login')) {
      // TODO(You): Fetch your access token and plug it in
      //final token = await _tokenStorage.getToken();
      final token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNzE1NzcwNTk5LCJleHAiOjE3MTgzNjI1OTl9.WVHwc1axDAOnAJNe1-afqGarvzqKpsKiLUjcmz_3mQg';
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
