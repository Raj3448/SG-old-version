import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/feature/user_profile/repository/local/user_details_cache.dart';
import 'package:silver_genie/feature/user_profile/services/i_user_facade.dart';

part 'user_details_store.g.dart';

class UserDetailStore = _UserDetailStoreBase with _$UserDetailStore;

abstract class _UserDetailStoreBase with Store {
  _UserDetailStoreBase(this.userDetailServices, this.userDetailsCache);

  final IUserFacades userDetailServices;

  final UserDetailsCache userDetailsCache;

  @observable
  bool isInitialised = false;

  @observable
  bool updateSuccess = false;

  @observable
  User? userDetails;

  @observable
  bool isLoadingUserInfo = false;

  @observable
  bool isUpdatingUserInfo = false;

  @observable
  String? updateFailureMessage;

  @computed
  String get name => userDetails == null
      ? '---'
      : [userDetails?.firstName ?? '', userDetails?.lastName ?? '']
          .join(' ')
          .trim();

  @action
  void init() {
    if (isInitialised) {
      return;
    }
    fetchUserDetailsFromCache().then((_) {
      /// After initializing the state with data from the cache, refetching to
      /// update the data and update the cache
      getUserDetails();
    });
    isInitialised = true;
  }

  @action
  void getUserDetails() {
    isLoadingUserInfo = true;
    userDetailServices.fetchUserDetailsFromServer().then((user) {
      user.fold((l) => null, (r) => userDetails = r);
      isLoadingUserInfo = false;
    });
  }

  @action
  void updateUserDetails(User newInstance) {
    updateSuccess = false;
    updateFailureMessage = null;
    isUpdatingUserInfo = true;
    userDetailServices
        .updateUserDetails(user: newInstance)
        .then((userDetailsResult) {
      userDetailsResult.fold((l) {
        updateFailureMessage = l.maybeMap(
            socketException: (_) =>
                'Failed to update, check your internet connection!',
            orElse: () => 'Failed to update the user data');
      }, (r) {
        userDetails = r;
        updateSuccess = true;
      });
      isUpdatingUserInfo = false;
    });
  }

  @action
  Future<void> fetchUserDetailsFromCache() async {
    isLoadingUserInfo = true;

    final userInfo = await userDetailsCache.getUserDetails();

    runInAction(() {
      if (userInfo != null) {
        userDetails = userInfo;
      }
      isLoadingUserInfo = false;
    });
  }

  @action
  void updateUserDataWithProfileImg(
      {required File fileImage, required User userInstance}) {
    isUpdatingUserInfo = true;
    updateSuccess = false;
    updateFailureMessage = null;
    userDetailServices
        .updateUserDataWithProfileImg(
            fileImage: fileImage, userInfo: userInstance)
        .then((user) {
      user.fold((l) {
        updateFailureMessage = l.maybeMap(
            socketException: (_) =>
                'Failed to update, check your internet connection!',
            orElse: () => 'Failed to update the user data');
      }, (r) {
        userDetails = r;
        updateSuccess = true;
      });
      isUpdatingUserInfo = false;
    });
  }

  void clear() {
    isInitialised = false;
    updateSuccess = false;
    userDetails = null;
    isLoadingUserInfo = false;
    isUpdatingUserInfo = false;
    updateFailureMessage = null;
  }
}

extension UserExtension on User {
  String? get profileImgUrl =>
      profileImg?.url != null ? '${Env.serverUrl}${profileImg?.url}' : null;

  String get name => [firstName, lastName].join(' ').trim();
}
