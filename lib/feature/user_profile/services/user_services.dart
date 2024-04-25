//import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/feature/user_profile/services/i_user_facade.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';

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
  Future<Either<Failure, UserDetails>> fetchUserDetailsFromApi() async {
    //  API call here to fetch user details
    try {
      // final response = await HttpClient().get<String>('/UserDetails');

      // if (response.statusCode == 200) {
      //   final json = jsonDecode(response.data!);

      //   return Right(Success(
      //       userDetails: UserDetails.fromJson(json as Map<String, dynamic>)));
      // } else {
      //   return Left(Failure.badResponse());
      // }
      return Right(_userDetails);
    } on SocketException {
      return const Left(Failure.socketException());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }
  
  @override
  Future<Either<Failure, UserDetails>> updateUserDetails({@required UserDetails? userDetails}) async{
    try {
      // final response = await HttpClient().post<String>('/UserDetails/id',
      //     data: jsonEncode(userDetails.toJson()));

      // if (response.statusCode == 200) {
      //   final json = jsonDecode(response.data!);

      //   return Right(Success(
      //       userDetails: UserDetails.fromJson(json as Map<String, dynamic>),
      //       successMsg: 'User Details Update Successfully'));
      // } else {
      //   return Left(Failure.badResponse());
      // }
      _userDetails = userDetails!;
      return Right(_userDetails);
    } on SocketException {
      return const Left(Failure.socketException());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }
  // Update user details through API
}