// ignore_for_file: library_private_types_in_public_api

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/utils/token_manager.dart';
import 'package:silver_genie/feature/bookings/store/booking_service_store.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';
import 'package:silver_genie/feature/notification/services/notification_service.dart';
import 'package:silver_genie/feature/notification/store/notification_store.dart';
import 'package:silver_genie/feature/user_profile/repository/local/user_details_cache.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

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

  @observable
  bool isLogoutLoading = false;

  @observable
  String? logoutFailure;

  @observable
  bool logoutSuccess = false;

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
    isLogoutLoading = true;
    userCache.clearUserDetails().then((value) {
      tokenManager.deleteToken().then((value) => {authTokenExits = false});
    });
    GetIt.I<MembersStore>().clear();
    GetIt.I<UserDetailStore>().clear();
    GetIt.I<BookingServiceStore>().clear();
    GetIt.I<NotificationStore>().clear();
    GetIt.I<NotificationServices>()
        .storeFcmTokenIntoServer(fcmToken: null)
        .then((value) {
      value.fold((l) {
        l.maybeMap(
          socketError: (value) => logoutFailure = 'No Internet',
          orElse: () => logoutFailure = 'Something went wrong',
        );
      }, (r) {
        logoutSuccess = true;
      });
      isLogoutLoading = false;
    });
  }
}
