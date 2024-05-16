// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/failure/auth_failure.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/feature/login-signup/services/auth_service.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  final authService = GetIt.I<AuthService>();
  @observable
  bool isEmail = false;

  @observable
  String? selectCountryDialCode;

  @observable
  bool isLoading = false;

  @observable
  Either<AuthFailure, void>? authFailure;

  // @action
  // Future<void> verifyOtp(
  //   String otp,
  //   String phoneNumber,
  //   BuildContext context,
  // ) {
  //   try {
  //     isLoading = true;
  //   } catch (e) {
  //     // return ;
  //   } finally {
  //     isLoading = false;
  //   }
  // }

  @action
  void signup(
    String firstName,
    String lastName,
    String dob,
    String email,
    String phoneNumber,
    BuildContext context,
  ) {
    isLoading = true;
    authFailure = null;
    Future.delayed(Duration(seconds: 2)).then(
      (value) => authService
          .signup(
            firstName,
            lastName,
            dob,
            email,
            phoneNumber,
            context,
          )
          .then(
            (value) => {
              isLoading = false,
              authFailure = value,
            },
          ),
    );

    print('done');
  }
}
