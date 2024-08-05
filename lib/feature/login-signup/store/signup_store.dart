// ignore_for_file: library_private_types_in_public_api

import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/failure/auth_failure.dart';
import 'package:silver_genie/feature/login-signup/services/auth_service.dart';
part 'signup_store.g.dart';

class SignupStore = _SignupStoreBase with _$SignupStore;

abstract class _SignupStoreBase with Store {
  _SignupStoreBase(this.authService);

  final AuthService authService;

  @observable
  bool isLoading = false;

  @observable
  String firstName = '';

  @observable
  String lastName = '';

  @observable
  String dob = '';

  @observable
  String email = '';

  @observable
  String phoneNumber = '';

  @observable
  Either<AuthFailure, void>? authFailure;

  @observable
  String? selectCountryDialCode;

  @observable
  String? selectCountryCode;

  @action
  void signup(
    String firstName,
    String lastName,
    String dob,
    String email,
    String phoneNumber,
  ) {
    isLoading = true;
    authFailure = null;
    authService.signup(firstName, lastName, dob, email, phoneNumber).then(
          (value) => {
            isLoading = false,
            authFailure = value,
          },
        );
    isLoading = false;
  }
}
