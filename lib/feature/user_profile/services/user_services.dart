//import 'dart:convert';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
// import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';

class UserDetailServices {
  UserDetailServices();

  UserDetails _userDetails = UserDetails(
      fullname: 'Varun Nair',
      gender: 'Male',
      dateBirth: '16-02-2002',
      mobileNum: "+91 1234567890",
      emailId: 'example@gmail.com',
      address:
          'No 10 Anna nagar 1 st street, near nehru park, chennai, TamilNadu 600028',
      country: 'India',
      state: 'Maharashtra',
      city: 'Pune',
      postalCode: 411041);

  Future<Either<Failure, Success>> fetchUserDetailsFromApi() async {
    //  API call here to fetch user details
    try {
      // final response = await HttpClient().get<String>('/UserDetails');

      // if (response.statusCode == 200) {
      //   final json = jsonDecode(response.data!);

      //   return Right(Success(
      //       userDetails: UserDetails.fromJson(json as Map<String, dynamic>)));
      // } else {
      //   return Left(Failure(errormessage: 'Bad Response'));
      // }
      return Right(Success(userDetails: _userDetails));
    } on SocketException {
      return Left(Failure(errormessage: 'No internet connection'));
    } catch (error) {
      return Left(Failure(errormessage: 'Something went wrong'));
    }
  }

  // Update user details through API
  Future<Either<Failure, Success>> updateUserDetails(
      UserDetails userDetails) async {
    try {
      // final response = await HttpClient().post<String>('/UserDetails/id',
      //     data: jsonEncode(userDetails.toJson()));

      // if (response.statusCode == 200) {
      //   final json = jsonDecode(response.data!);

      //   return Right(Success(
      //       userDetails: UserDetails.fromJson(json as Map<String, dynamic>),
      //       successMsg: 'User Details Update Successfully'));
      // } else {
      //   return Left(Failure(errormessage: 'Bad Response'));
      // }
      _userDetails = userDetails;
      return Right(Success(userDetails: _userDetails));
    } on SocketException {
      return Left(Failure(errormessage: 'No internet connection'));
    } catch (error) {
      return Left(Failure(errormessage: 'Something went wrong'));
    }
  }
}

class Failure {
  Failure({required this.errormessage});
  final String errormessage;
}

class Success {
  Success({required this.userDetails, String? successMsg});
  final UserDetails userDetails;
}
