// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  @observable
  bool isEmail = false;

  @observable
  String? selectCountryDialCode;
}
