// ignore_for_file: library_private_types_in_public_api

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
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
}
