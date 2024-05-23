import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/feature/user_profile/repository/local/user_details_cache.dart';
import 'package:silver_genie/feature/user_profile/services/i_user_facade.dart';

part 'user_details_store.g.dart';

class UserDetailStore = _UserDetailStoreBase with _$UserDetailStore;

abstract class _UserDetailStoreBase with Store {
  _UserDetailStoreBase(this.userDetailServices);

  final IUserFacades userDetailServices;

  @observable
  bool isInitialised = false;

  @observable
  User? userDetails;

  @observable
  bool isLoadingUserInfo = false;

  @observable
  bool isUpdatingUserInfo = false;

  @observable
  String? updateFailureMessage;

  @computed
  String? get profileImgUrl => userDetails?.profileImg?.url != null
      ? '${Env.serverUrl}${userDetails?.profileImg?.url}'
      : null;

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
  Future<void> updateUserDetails(User newInstance) async {
    updateFailureMessage = null;
    isUpdatingUserInfo = true;
    final userDetailsResult =
        await userDetailServices.updateUserDetails(user: newInstance);
    userDetailsResult.fold((l) {
      updateFailureMessage = l.maybeMap(
          socketException: (_) =>
              'Failed to update, check your internet connection!',
          orElse: () => 'Failed to update the user data');
    }, (r) {
      userDetails = r;
    });
    isUpdatingUserInfo = false;
  }

  @action
  Future<void> fetchUserDetailsFromCache() async {
    isLoadingUserInfo = true;
    final userInfo = await GetIt.I<UserDetailsCache>().getUserDetails();
    if (userInfo != null) {
      userDetails = userInfo;
    }
    isLoadingUserInfo = false;
    return;
  }

  @action
  void updateUserDataWithProfileImg(
      {required File fileImage, required User userInstance}) {
    isUpdatingUserInfo = true;
    userDetailServices
        .updateUserDataWithProfileImg(
            fileImage: fileImage, userInfo: userInstance)
        .then((user) {
      user.fold((l) => null, (r) => userDetails = r);
      isUpdatingUserInfo = false;
    });
  }
}

extension UserExtension on User {
  String? get profileImgUrl => profileImg?.url != null
      ? '${Env.serverUrl.removeTrailingSlash()}${profileImg?.url}'
      : null;

  String get name => [firstName, lastName].join(' ').trim();
}

extension StringExtension on String {
  // Method to remove trailing slash
  String removeTrailingSlash() {
    // Check if the string ends with '/'
    if (endsWith('/')) {
      // Remove the last character

      final result = substring(0, length - 1);
      return result;
    }
    // Return the original string if there's no trailing '/'
    return this;
  }
}
