// ignore_for_file: public_member_api_docs, sort_constructors_first
//import 'dart:convert';
// ignore_for_file: lines_longer_than_80_chars
import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/feature/user_profile/repository/local/user_details_cache.dart';
import 'package:silver_genie/feature/user_profile/services/i_user_facade.dart';

class UserDetailServices implements IUserFacades {
  final UserDetailsCache _userDetailCache;
  UserDetailServices(
    this._userDetailCache,
  );


  UserDetails _userDetails = UserDetails(
      id: 1,
      firstName: 'Varun',
      lastName: 'Nair',
      gender: 'Male',
      dateOfBirth: DateTime.parse('2002-02-16'),
      phoneNumber: '+91 1234567890',
      email: 'example@gmail.com',
      age: 44,
      address: const Address(
        streetAddress:
            'No 10 Anna nagar 1 st street, near nehru park, chennai, TamilNadu 600028',
        country: 'India',
        state: 'Maharashtra',
        city: 'Pune',
        postalCode: '411065',
      ),
      username: '',
      confirmed: false,
      blocked: false,
      relation: 'self',
      uniqueKey: '',
      createdAt: DateTime.parse("2024-05-08T10:44:21.044Z"),
      updatedAt: DateTime.parse("2024-05-08T10:46:26.015Z"),
      userTags: null);

  @override
  Future<Either<Failure, UserDetails>> fetchUserDetailsFromApi() async {
    //  API call here to fetch user details
    try {
      final cachedUserDetails = await _userDetailCache.getUserDetails();
    if (cachedUserDetails != null) {
      //returning catched details
      return Right(_userDetails);
    } else {
      
      // Return the fetched user details from api
      return Right(_userDetails);
    }
      
    } on SocketException {
      return const Left(Failure.socketException());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }

  @override
  Future<Either<Failure, UserDetails>> updateUserDetails({
    required UserDetails userDetails,
  }) async {
    try {
      // final response = await HttpClient().post<String>('/api/users/${userDetails.id}',
      //     data: jsonEncode(userDetails.toJson()));

      // if (response.statusCode == 200) {
      //   await _userDetailCache.saveUserDetails(userDetails);
      //   final json = jsonDecode(response.data!);

      //   return Right(UserDetails.fromJson(json as Map<String, dynamic>));
      // } else {
      //   return const Left(Failure.badResponse());
      // }
      _userDetails = userDetails;
      return Right(_userDetails);
    } on SocketException {
      return const Left(Failure.socketException());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }
  // Update user details through API
}
