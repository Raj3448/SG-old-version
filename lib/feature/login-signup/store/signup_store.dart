import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/failure/auth_failure.dart';
import 'package:silver_genie/feature/login-signup/services/auth_service.dart';
part 'signup_store.g.dart';

class SignupStore = _SignupStoreBase with _$SignupStore;

abstract class _SignupStoreBase with Store {
  final authService = GetIt.I<AuthService>();
  @observable
  bool isLoading = false;

  @observable
  Either<AuthFailure, void>? authFailure;

  @observable
  String? selectCountryDialCode;

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
    authService
        .signup(
          firstName,
          lastName,
          dob,
          email,
          phoneNumber,
        )
        .then(
          (value) => {
            isLoading = false,
            authFailure = value,
          },
        );
  }
}
