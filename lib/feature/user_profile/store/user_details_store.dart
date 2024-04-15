import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
part 'user_details_store.g.dart';

class UserDetailStore = _UserDetailStoreBase with _$UserDetailStore;

abstract class _UserDetailStoreBase with Store {
  @observable
  UserDetails userDetails = UserDetails(
      fullname: 'Rajkumar Chavan',
      gender: 'Male',
      dateBirth: '16-02-2002',
      mobileNum: "+91 1234567890",
      emailId: 'example@gmail.com',
      address: 'No 10 Anna nagar 1 st street, near nehru park, chennai, TamilNadu 600028',
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
