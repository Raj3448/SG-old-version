// ignore_for_file: library_private_types_in_public_api

import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/failure/auth_failure.dart';
import 'package:silver_genie/feature/login-signup/services/auth_service.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  _LoginStoreBase(this.authService);
  final AuthService authService;

  @observable
  bool isEmail = false;

  @observable
  String? selectCountryDialCode;

  @observable
  String? selectCountryCode;

  @observable
  bool isLoading = false;

  @observable
  String identifier = '';

  @observable
  Either<AuthFailure, void>? authFailure;

  @observable
  String? selectCountryFlagEmoji;

  @action
  void login(
    String identifier,
  ) {
    isLoading = true;
    authFailure = null;
    authService
        .login(
          identifier,
        )
        .then(
          (value) => {
            isLoading = false,
            authFailure = value,
          },
        );
  }
}
