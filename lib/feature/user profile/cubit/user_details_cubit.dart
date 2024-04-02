import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:silver_genie/feature/user%20profile/model/user_details.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit() : super(UserDetailsInitial());

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

  UserDetails get getCurrentUserDetails => userDetails;

  Future<UserDetails> getUserDetails() async {
    
    return userDetails;
  }

  Future<void> updateUserDetails(UserDetails newInstance) async {
    userDetails = newInstance;
  }
}


//dd-MM-yyyy