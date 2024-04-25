// ignore_for_file: inference_failure_on_function_invocation

import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';

abstract class IAuthService {
  Future<Either<Failure, void>> loginWithNumber(String number);
  Future<Either<Failure, void>> loginWithEmail(String email);
  Future<Either<Failure, void>> signup(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String dob,
  );
  Future<Either<Failure, void>> verifyOtp(String otp);
}

class AuthService implements IAuthService {
  @override
  Future<Either<Failure, void>> loginWithNumber(String number) async {
    try {
      final dio = GetIt.I<HttpClient>();

      final response = dio.post('https://silvergenie.com/api/v1/login');
      return const Right(null);
    } catch (e) {
      return const Left(Failure.someThingWentWrong());
    }
  }

  @override
  Future<Either<Failure, void>> loginWithEmail(String email) async {
    try {
      final dio = GetIt.I<HttpClient>();

      final response = dio.post('https://silvergenie.com/api/v1/login');
      return const Right(null);
    } catch (e) {
      return const Left(Failure.someThingWentWrong());
    }
  }

  @override
  Future<Either<Failure, void>> signup(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String dob,
  ) async {
    try {
      final dio = GetIt.I<HttpClient>();

      final response = dio.post('https://silvergenie.com/api/v1/login');
      return const Right(null);
    } catch (e) {
      return const Left(Failure.someThingWentWrong());
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(String otp) async {
    try {
      final dio = GetIt.I<HttpClient>();

      final response = dio.post('https://silvergenie.com/api/v1/login');
      return const Right(null);
    } catch (e) {
      return const Left(Failure.someThingWentWrong());
    }
  }
}
