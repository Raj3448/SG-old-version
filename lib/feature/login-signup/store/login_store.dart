// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/failure/auth_failure.dart';
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

  @action
  void login(
    String email,
    BuildContext context,
  ) {
    isLoading = true;
    authFailure = null;
    authService
        .loginWithEmail(
          email,
          context,
        )
        .then(
          (value) => {
            isLoading = false,
            authFailure = value,
          },
        );
  }
}
