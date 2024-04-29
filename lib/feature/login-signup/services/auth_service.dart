// ignore_for_file: inference_AuthFailure_on_function_invocation, inference_failure_on_function_invocation

import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/auth_failure.dart';
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
  );
  Future<Either<AuthFailure, void>> verifyOtp(String otp);
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
    try {
      final response = httpClient.post('https://silvergenie.com/api/v1/login');
      return const Right(null);
    } catch (e) {
      return const Left(AuthFailure.invalidEmail());
    }
  }

  @override
  Future<Either<AuthFailure, void>> signup(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String dob,
  ) async {
    try {
      final response = httpClient.post('https://silvergenie.com/api/v1/login');
      return const Right(null);
    } catch (e) {
      return const Left(AuthFailure.tooManyRequests());
    }
  }

  @override
  Future<Either<AuthFailure, void>> verifyOtp(String otp) async {
    try {
      final response = httpClient.post('https://silvergenie.com/api/v1/login');
      return const Right(null);
    } catch (e) {
      return const Left(AuthFailure.otpInvalid());
    }
  }
}
