// ignore_for_file: inference_AuthFailure_on_function_invocation, inference_failure_on_function_invocation, deprecated_member_use, lines_longer_than_80_chars, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/failure/auth_failure.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/utils/http_client.dart';

abstract class IAuthService {
  Future<Either<AuthFailure, void>> loginWithNumber(String number);
  Future<Either<AuthFailure, void>> loginWithEmail(String email);
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
    String email,
    String phoneNumber,
    BuildContext context,
  );
}

class AuthService implements IAuthService {
  AuthService({required this.httpClient});

  final HttpClient httpClient;

  @override
  Future<Either<AuthFailure, void>> loginWithNumber(String number) async {
    try {
      final response = httpClient.post('https://silvergenie.com/api/v1/login');
      return const Right(null);
    } catch (e) {
      return const Left(AuthFailure.invalidPhoneNumber());
    }
  }

  @override
  Future<Either<AuthFailure, void>> loginWithEmail(String email) async {
    var data = <String, dynamic>{
      'email': email,
    };
    try {
      final response = await httpClient.post(
        'https://5103-2405-201-4004-910c-41f6-f800-b2b6-de5f.ngrok-free.app/api/login/',
        data: data,
      );
      print('Sent');
      print(response.data);
      if (response.statusCode == 200) {
        print(response.data);
        // await GoRouter.of(context).push(RoutesConstants.otpRoute);
        return const Right(null);
      } else {
        return const Left(AuthFailure.unknownError('Error unknown'));
      }
    } catch (e) {
      return const Left(AuthFailure.invalidEmail());
    }
  }

  @override
  Future<Either<AuthFailure, void>> signup(
    String firstName,
    String lastName,
    String dob,
    String email,
    String phoneNumber,
    String dob,
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
        'http://13.127.111.218:1337/api/auth/register-app-user',
        data: data,
      );
      if (request.statusCode == 200) {
        await GoRouter.of(context).pushNamed(
          RoutesConstants.otpRoute,
          pathParameters: {
            'email': email,
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
  Future<Either<AuthFailure, void>> verifyOtp(
    String otp,
    String email,
    String phoneNumber,
    BuildContext context,
  ) async {
    final phoneNumberData = <String, dynamic>{
      'otp': '1234',
      'phoneNumber': '91 9998880009',
    };
    try {
      final phoneNumberVerificationResponse = await httpClient.post(
        'http://13.127.111.218:1337/api/auth/register-complete',
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
