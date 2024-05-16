// ignore_for_file: inference_AuthFailure_on_function_invocation, inference_failure_on_function_invocation, deprecated_member_use, lines_longer_than_80_chars, use_build_context_synchronously

import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/failure/auth_failure.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/login-signup/store/login_store.dart';

abstract class IAuthService {
  Future<Either<AuthFailure, void>> loginWithNumber(
    String number,
    BuildContext context,
  );
  Future<Either<AuthFailure, void>> loginWithEmail(
    String email,
    BuildContext context,
  );
  Future<Either<AuthFailure, void>> signup(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String dob,
    BuildContext context,
  );
  Future<Either<AuthFailure, void>> verifyOtp(
    String otp,
    String phoneNumber,
    String email,
    BuildContext context,
  );
}

const baseUrl = 'http://172.27.112.1:1337/api';
final loginStore = GetIt.I<LoginStore>();

class AuthService implements IAuthService {
  AuthService({required this.httpClient});

  final HttpClient httpClient;

  @override
  Future<Either<AuthFailure, void>> loginWithNumber(
    String phoneNumber,
    BuildContext context,
  ) async {
    final data = <String, dynamic>{
      'phoneNumber': phoneNumber,
    };
    try {
      final request = await httpClient.post(
        '$baseUrl/login/',
        data: data,
      );
      if (request.statusCode == 200) {
        await GoRouter.of(context).pushNamed(
          RoutesConstants.otpRoute,
          pathParameters: {
            'email': 'email',
            'phoneNumber': phoneNumber,
          },
        );
        return const Right(null);
      } else {
        return const Left(AuthFailure.unknownError('Error unknown'));
      }
    } catch (e) {
      return const Left(AuthFailure.tooManyRequests());
    }
  }

  @override
  Future<Either<AuthFailure, void>> loginWithEmail(
    String email,
    BuildContext context,
  ) async {
    final data = <String, dynamic>{
      'identifier': email,
    };
    try {
      final request = await httpClient.post(
        '$baseUrl/login/',
        data: data,
      );
      if (request.statusCode == 200) {
        await GoRouter.of(context).pushNamed(
          RoutesConstants.otpRoute,
          pathParameters: {
            'email': email,
            'phoneNumber': 'phoneNumber',
          },
        );
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
    BuildContext context,
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
        // 'http://13.127.111.218:1337/api/auth/register-app-user',
        // 'http://api-dev.yoursilvergenie.com/api/auth/register-app-user',
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
  Future<Either<AuthFailure, void>> verifyOtp(
    String otp,
    String phoneNumber,
    String email,
    BuildContext context,
  ) async {
    final phoneNumberData = <String, dynamic>{
      'otp': otp,
      'phoneNumber': phoneNumber,
    };
    final emailData = <String, dynamic>{
      'otp': otp,
      'email': email,
    };
    try {
      final phoneNumberVerificationResponse = loginStore.isEmail
          ? await httpClient.post(
              // 'http://13.127.111.218:1337/api/auth/register-complete',
              '$baseUrl/verify-otp/',
              data: emailData,
            )
          : await httpClient.post(
              // 'http://13.127.111.218:1337/api/auth/register-complete',
              '$baseUrl/auth/register-complete',
              data: phoneNumberData,
            );
      if (phoneNumberVerificationResponse.statusCode == 200) {
        await GoRouter.of(context).pushReplacement(RoutesConstants.homeRoute);
      }
      return const Right(null);
    } catch (e) {
      return const Left(AuthFailure.otpInvalid());
    }
  }
}
