//import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silver_genie/feature/user_profile/services/i_user_facade.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/feature/user_profile/services/user_failure_or_success.dart';

class UserDetailServices implements IUserFacades{
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

  @override
  Future<Either<UserFailure, UserSuccess>> fetchUserDetailsFromApi() async {
    //  API call here to fetch user details
    try {
      // final response = await HttpClient().get<String>('/UserDetails');

      // if (response.statusCode == 200) {
      //   final json = jsonDecode(response.data!);

      //   return Right(Success(
      //       userDetails: UserDetails.fromJson(json as Map<String, dynamic>)));
      // } else {
      //   return Left(UserFailure.badResponse());
      // }
      return Right(UserSuccess.success(_userDetails));
    } on SocketException {
      return const Left(UserFailure.socketException());
    } catch (error) {
      return const Left(UserFailure.someThingWentWrong());
    }
  }
  
  @override
  Future<Either<UserFailure, UserSuccess>> updateUserDetails({@required UserDetails? userDetails}) async{
    try {
      // final response = await HttpClient().post<String>('/UserDetails/id',
      //     data: jsonEncode(userDetails.toJson()));

      // if (response.statusCode == 200) {
      //   final json = jsonDecode(response.data!);

      //   return Right(Success(
      //       userDetails: UserDetails.fromJson(json as Map<String, dynamic>),
      //       successMsg: 'User Details Update Successfully'));
      // } else {
      //   return Left(UserFailure.badResponse());
      // }
      _userDetails = userDetails!;
      return Right(UserSuccess.success(_userDetails));
    } on SocketException {
      return const Left(UserFailure.socketException());
    } catch (error) {
      return const Left(UserFailure.someThingWentWrong());
    }
  }

  // Update user details through API
  
}

class Failure {
  Failure({required this.errormessage});
  final String errormessage;
}

class Success {
  Success({required this.userDetails, String? successMsg});
  final UserDetails userDetails;
}