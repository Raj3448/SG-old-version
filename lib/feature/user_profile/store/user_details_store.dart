import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/feature/user_profile/services/user_services.dart';
import 'package:silver_genie/feature/user_profile/services/user_failure_or_success.dart';

part 'user_details_store.g.dart';

class UserDetailStore = _UserDetailStoreBase with _$UserDetailStore;

abstract class _UserDetailStoreBase with Store {
  final UserDetailServices _userDetailServices = UserDetailServices();
  @observable
  UserDetails? userDetails;

  @action
  Future<Either<UserFailure,UserSuccess>> getUserDetails() async {
    
      final userDetailsResult = await _userDetailServices.fetchUserDetailsFromApi();
      return userDetailsResult.fold(
        (failure) => Left(failure),
        (success) {
          userDetails = success.userDetails;
          return Right(success);
        },
      );
    
  }

  @action
  Future<Either<UserFailure, UserSuccess>> updateUserDetails(UserDetails newInstance) async {
    
      final userDetailsResult = await _userDetailServices.updateUserDetails(userDetails: newInstance);
      return userDetailsResult.fold(
        (failure) => Left(failure),
        (success) {
          userDetails = success.userDetails;
          return Right(success);
        },
      );
    
  }
}
