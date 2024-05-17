// ignore_for_file: library_private_types_in_public_api

import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/failure/auth_failure.dart';
import 'package:silver_genie/feature/login-signup/services/auth_service.dart';
part 'verify_otp_store.g.dart';

class VerityOtpStore = _VerityOtpStoreBase with _$VerityOtpStore;

abstract class _VerityOtpStoreBase with Store {
  final authService = GetIt.I<AuthService>();

  @observable
  bool isLoading = false;

  @observable
  Either<VerifyOTPFailure, void>? authFailure;

  @action
  void verifyOtp({
    required String otp,
    required String phoneNumber,
    required String email,
    bool isFromLoginPage = true,
  }) {
    isLoading = true;
    authFailure = null;
    authService
        .verifyOtp(otp: otp, phoneNumber: phoneNumber, email: email)
        .then(
          (value) => {
            isLoading = false,
            authFailure = value,
          },
        );
  }
}
