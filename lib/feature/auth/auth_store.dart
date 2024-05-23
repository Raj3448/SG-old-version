// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/utils/token_manager.dart';
import 'package:silver_genie/feature/user_profile/repository/local/user_details_cache.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  _AuthStoreBase({required this.tokenManager, required this.userCache});
  final TokenManager tokenManager;

  final UserDetailsCache userCache;
  @observable
  bool initialised = false;

  @observable
  bool authTokenExits = false;

  @observable
  bool userDetailsCacheExists = false;

  @computed
  bool get isAuthenticated => authTokenExits && userDetailsCacheExists;

  @action
  void refresh() {
    tokenManager.getToken().then(
      (value) {
        if (value != null) {
          authTokenExits = true;
        }
        userCache.getUserDetails().then((user) {
          if (user != null) {
            userDetailsCacheExists = true;
          }
        });
        initialised = true;
      },
    );
  }

  @action
  void logout() {
    userCache.clearUserDetails().then((value) {
      tokenManager.deleteToken().then((value) => {authTokenExits = false});
    });
  }
}
