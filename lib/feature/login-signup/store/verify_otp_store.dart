// ignore_for_file: library_private_types_in_public_api

import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/failure/auth_failure.dart';
import 'package:silver_genie/feature/login-signup/services/auth_service.dart';
part 'verify_otp_store.g.dart';

class VerityOtpStore = _VerityOtpStoreBase with _$VerityOtpStore;

abstract class _VerityOtpStoreBase with Store {
  _VerityOtpStoreBase(this.authService);
  final AuthService authService;

  @observable
  bool isLoading = false;

  @observable
  Either<VerifyOTPFailure, void>? authFailure;

  @action
  void verifyOtp({
    required String otp,
    required String phoneNumber,
    required String email,
    required bool isFromLoginPage,
  }) {
    isLoading = true;
    authFailure = null;
    authService
        .verifyOtp(
          otp: otp,
          phoneNumber: phoneNumber,
          email: email,
          isFromLoginPage: isFromLoginPage,
        )
        .then(
          (value) => {
            isLoading = false,
            authFailure = value,
          },
        );
  }
}
