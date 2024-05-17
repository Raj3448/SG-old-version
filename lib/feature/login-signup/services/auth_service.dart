// ignore_for_file: inference_AuthFailure_on_function_invocation, inference_failure_on_function_invocation, deprecated_member_use, lines_longer_than_80_chars, use_build_context_synchronously

import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/auth_failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/core/utils/token_manager.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/feature/user_profile/repository/local/user_details_cache.dart';

abstract class IAuthService {
  Future<Either<AuthFailure, void>> login(String identifier);
  Future<Either<AuthFailure, void>> signup(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String dob,
  );
  Future<Either<VerifyOTPFailure, void>> verifyOtp(
      {required String otp,
      required String phoneNumber,
      required String email,
      bool isFromLoginPage});
}

const baseUrl = 'api';

class AuthService implements IAuthService {
  AuthService(
      {required this.httpClient,
      required this.userDetailsCache,
      required this.tokenManager});

  final HttpClient httpClient;
  final UserDetailsCache userDetailsCache;

  final TokenManager tokenManager;

  @override
  Future<Either<AuthFailure, void>> login(
    String identifier,
  ) async {
    final data = <String, dynamic>{
      'identifier': identifier,
    };
    try {
      final request = await httpClient.post(
        '$baseUrl/login/',
        data: data,
      );
      if (request.statusCode == 200) {
        return const Right(null);
      } else {
        return const Left(AuthFailure.unknownError('Error unknown'));
      }
    } catch (e) {
      return const Left(AuthFailure.tooManyRequests());
    }
  }

  @override
  Future<Either<AuthFailure, void>> signup(
    String firstName,
    String lastName,
    String dob,
    String email,
    String phoneNumber,
  ) async {
    final data = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'email': email,
      'phoneNumber': phoneNumber,
    };
    try {
      final request = await httpClient.post(
        '$baseUrl/auth/register-app-user',
        data: data,
      );
      if (request.statusCode == 200) {
        return const Right(null);
      } else {
        return const Left(AuthFailure.unknownError('Error unknown'));
      }
    } catch (e) {
      return const Left(AuthFailure.tooManyRequests());
    }
  }

  @override
  Future<Either<VerifyOTPFailure, void>> verifyOtp({
    required String otp,
    required String phoneNumber,
    required String email,
    bool isFromLoginPage = true,
  }) async {
    final signUpData = <String, dynamic>{
      'otp': otp,
      'phoneNumber': phoneNumber,
      'email': email,
    };
    final emailData = <String, dynamic>{
      'otp': otp,
      'email': email,
    };
    try {
      final phoneNumberVerificationResponse = (isFromLoginPage)
          ? await httpClient.post(
              '$baseUrl/verify-otp/',
              data: emailData,
            )
          : await httpClient.post(
              '$baseUrl/auth/register-complete',
              data: signUpData,
            );
      if (phoneNumberVerificationResponse.statusCode == 200) {
        final token =
            phoneNumberVerificationResponse?.data['data']['AUTH_TOKEN'];

        if (token is String) {
          await tokenManager.saveToken(token);
        }

        if (phoneNumberVerificationResponse.data['data']['userDetails'] !=
            null) {
          final User user = User.fromJson(phoneNumberVerificationResponse
              .data['data']['userDetails'] as Map<String, dynamic>);

          await userDetailsCache.saveUserDetails(user);
        }
        return const Right(null);
      } else {
        return const Left(VerifyOTPFailure.unknown());
      }
    } catch (e) {
      return const Left(VerifyOTPFailure.unknown());
    }
  }
}
