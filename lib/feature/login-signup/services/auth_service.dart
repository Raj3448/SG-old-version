// ignore_for_file: inference_AuthFailure_on_function_invocation, inference_failure_on_function_invocation, deprecated_member_use, lines_longer_than_80_chars, use_build_context_synchronously, avoid_dynamic_calls

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
  Future<Either<VerifyOTPFailure, void>> verifyOtp({
    required String otp,
    required String phoneNumber,
    required String email,
    required bool isFromLoginPage,
  });
}

class AuthService implements IAuthService {
  AuthService({
    required this.httpClient,
    required this.userDetailsCache,
    required this.tokenManager,
  });

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
        '/api/login/',
        data: data,
      );
      if (request.statusCode == 200) {
        return const Right(null);
      }

      if (request.statusCode == 400) {
        final dynamic code = request.data?['error']?['details']?['name'];
        final errorCode = code is String ? code : null;

        if (errorCode == null) {
          return const Left(AuthFailure.unknownError('Error unknown'));
        }
        if (errorCode == LoginErrorCodes.invalidEmail) {
          return const Left(AuthFailure.invalidEmail());
        }

        if (errorCode == LoginErrorCodes.userDoesNotExit) {
          return const Left(AuthFailure.userNotFound());
        }
        return const Left(AuthFailure.unknownError('Error unknown'));
      } else if (request.statusCode == 500) {
        return const Left(AuthFailure.internalServerError());
      } else if (request.statusCode == 502) {
        return const Left(AuthFailure.badGatewayError());
      }
      return const Left(AuthFailure.unknownError('Error unknown'));
    } catch (_) {
      return const Left(AuthFailure.unknownError('Error unknown'));
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
        '/api/auth/register-app-user',
        data: data,
      );
      if (request.statusCode == 200) {
        return const Right(null);
      }

      if (request.statusCode == 400) {
        final dynamic code = request.data?['error']?['details']?['name'];
        final errorCode = code is String ? code : null;

        if (errorCode == null) {
          return const Left(AuthFailure.unknownError('Error unknown'));
        }
        if (errorCode == SignUpErrorCodes.userAlreadyExists) {
          return const Left(AuthFailure.userAlreadyExists());
        }
        if (errorCode == SignUpErrorCodes.invalidEmail) {
          return const Left(AuthFailure.invalidEmail());
        }
        if (errorCode == SignUpErrorCodes.invalidPhoneNumber) {
          return const Left(AuthFailure.invalidPhoneNumber());
        }

        return const Left(AuthFailure.unknownError('Unknown error'));
      } else if (request.statusCode == 500) {
        return const Left(AuthFailure.internalServerError());
      } else if (request.statusCode == 502) {
        return const Left(AuthFailure.badGatewayError());
      }

      return const Left(AuthFailure.unknownError('Unknown error'));
    } catch (e) {
      return const Left(AuthFailure.networkError());
    }
  }

  @override
  Future<Either<VerifyOTPFailure, void>> verifyOtp({
    required String otp,
    required String? phoneNumber,
    required String? email,
    required bool isFromLoginPage,
  }) async {
    final signUpData = <String, dynamic>{
      'otp': otp,
      'phoneNumber': phoneNumber,
      'email': email,
    };
    final loginData = <String, dynamic>{
      'otp': otp,
      'identifier': email ?? phoneNumber,
    };
    try {
      final phoneNumberVerificationResponse = isFromLoginPage
          ? await httpClient.post(
              '/api/verify-otp/',
              data: loginData,
            )
          : await httpClient.post(
              '/api/auth/register-complete',
              data: signUpData,
            );
      if (phoneNumberVerificationResponse.statusCode == 200) {
        final token =
            phoneNumberVerificationResponse.data['data']['AUTH_TOKEN'];
        if (token is String) {
          await tokenManager.saveToken(token);
        }
        if (phoneNumberVerificationResponse.data['data']['userDetails'] !=
            null) {
          final user = User.fromJson(
            phoneNumberVerificationResponse.data['data']['userDetails']
                as Map<String, dynamic>,
          );
          await userDetailsCache.saveUserDetails(user);
        }
        return const Right(null);
      } else if (phoneNumberVerificationResponse.statusCode == 400) {
        final dynamic code =
            phoneNumberVerificationResponse.data?['error']?['details']?['name'];
        final errorCode = code is String ? code : null;

        if (errorCode == null) {
          return const Left(VerifyOTPFailure.unknown());
        }
        if (errorCode == VerifyOTPErrorCodes.invalidOTP) {
          return const Left(VerifyOTPFailure.invalidOTP());
        }

        return const Left(VerifyOTPFailure.unknown());
      }

      return const Left(VerifyOTPFailure.unknown());
    } catch (e) {
      return const Left(VerifyOTPFailure.unknown());
    }
  }
}

abstract class LoginErrorCodes {
  static const String invalidEmail = 'INVALID_EMAIL';
  static const String userDoesNotExit = 'USER_DOESNT_EXIST';
}

abstract class SignUpErrorCodes {
  static const String userAlreadyExists = 'USER_ALREADY_EXIST';
  static const String invalidEmail = 'INVALID_EMAIL';
  static const String invalidPhoneNumber = 'INVALID_PHONE_NUMBER';
}

abstract class VerifyOTPErrorCodes {
  static const String invalidOTP = 'INVALID_OTP';
}
