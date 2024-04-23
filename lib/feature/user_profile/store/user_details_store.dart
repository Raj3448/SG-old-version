import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/feature/user_profile/services/i_user_facade.dart';
import 'package:silver_genie/feature/user_profile/services/user_failure.dart';

part 'user_details_store.g.dart';

class UserDetailStore = _UserDetailStoreBase with _$UserDetailStore;

abstract class _UserDetailStoreBase with Store {
  _UserDetailStoreBase(this.userDetailServices);

  final IUserFacades userDetailServices;

  @observable
  Either<UserFailure, UserDetails>? userDetails;

  @observable
  bool isLoading = false;

  @action
  Future<void> getUserDetails() async {
    isLoading = true;
    userDetails = await userDetailServices.fetchUserDetailsFromApi();
    isLoading = false;
  }

  @action
  Future<void> updateUserDetails(UserDetails newInstance) async {
    isLoading = true;
    final Either<UserFailure, UserDetails> userDetailsResult =
        await userDetailServices.updateUserDetails(userDetails: newInstance);
    userDetailsResult.fold((l) {}, (r) {
      userDetails = userDetailsResult;
    });
    isLoading = false;
  }
}
