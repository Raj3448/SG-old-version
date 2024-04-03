import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
part '../../user profile/store/user_details_store.g.dart';

class UserDetailStore = _UserDetailStoreBase with _$UserDetailStore;

abstract class _UserDetailStoreBase with Store {
  @observable
  UserDetails userDetails = UserDetails(
      fullname: 'Rajkumar Chavan',
      gender: 'Male',
      dateBirth: '16-02-2002',
      mobileNum: "+91 1234567890",
      emailId: 'example@gmail.com',
      address: 'xyz address',
      country: 'India',
      state: 'Maharashtra',
      city: 'Pune',
      postalCode: 411041);

  @action
  Future<UserDetails> getUserDetails() async {
    return userDetails;
  }

  @action
  Future<void> updateUserDetails(UserDetails newInstance) async {
    userDetails = newInstance;
  }
}
