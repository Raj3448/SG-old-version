// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:fpdart/fpdart.dart';
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
  Timer? _timer;

  @observable
  int countdown = 40;

  @observable
  bool showResendButton = false;

  @observable
  bool isResendLoading = false;

  @observable
  bool isError = false;

  @action
  void verifyOtp({
    required String otp,
    required String? phoneNumber,
    required String? email,
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

  @action
  void startTimer() {
    resetTimer();
    showResendButton = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        timer.cancel();
        showResendButton = true;
      } else {
        countdown--;
      }
    });
  }

  @action
  void resetTimer() {
    _timer?.cancel();
    countdown = 40;
  }

  @action
  void resendOTPLogin(String identifier) {
    isResendLoading = true;
    isError = false;
    authService
        .login(
          identifier,
        )
        .then(
          (value) => {
            isResendLoading = false,
            value.fold(
              (l) => isError = true,
              (r) => startTimer(),
            ),
          },
        );
    resetTimer();
  }

  void dispose() {
    _timer?.cancel();
  }

  @action
  void resendOTPSignup(
    String firstName,
    String lastName,
    String dob,
    String email,
    String phoneNumber,
  ) {
    isResendLoading = true;
    isError = false;
    authService.signup(firstName, lastName, dob, email, phoneNumber).then(
          (value) => {
            isResendLoading = false,
            value.fold(
              (l) => isError = true,
              (r) => startTimer(),
            ),
          },
        );
  }
}
