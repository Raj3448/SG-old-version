// ignore_for_file: public_member_api_docs, sort_constructors_first
//import 'dart:convert';
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/members/model/epr_models.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/feature/user_profile/repository/local/user_details_cache.dart';
import 'package:silver_genie/feature/user_profile/services/i_user_facade.dart';

class UserDetailServices implements IUserFacades {
  final UserDetailsCache _userDetailCache;
  HttpClient httpClient;
  UserDetailServices(
    this._userDetailCache,
    this.httpClient,
  );

  UserDetails _userDetails = UserDetails(
    user: User(
      id: 1,
      firstName: 'Varun',
      lastName: 'Nair',
      gender: 'Male',
      dateOfBirth: DateTime.parse('2002-02-16'),
      phoneNumber: '+91 1234567890',
      email: 'example@gmail.com',
      address: Address(
        streetAddress:
            'No 10 Anna nagar 1 st street, near nehru park, chennai, TamilNadu 600028',
        country: 'India',
        state: 'Maharashtra',
        city: 'Pune',
        postalCode: '411065',
        id: 1,
      ),
      username: '',
      confirmed: false,
      blocked: false,
      relation: 'self',
      uniqueKey: '',
      createdAt: DateTime.parse('2024-05-08T10:44:21.044Z'),
      updatedAt: DateTime.parse('2024-05-08T10:46:26.015Z'),
      userTags: null,
    ),
    userInsurance: [
      UserInsurance.fromJson({
        "id": 1,
        "insuranceProvider": "Tata birla",
        "policyNumber": "112233445599",
        "contactPerson": "Tesla owner",
        "contactNumber": "91 8888888880",
        "expiryDate": "2025-05-10"
      })
    ],
    emergencyContacts: [
      EmergencyContact.fromJson({
        "id": 1,
        "contactDegree": "Tata birla",
        "policyNumber": "112233445599",
        "contactPersonName": "Tesla owner",
        "contactNumber": "91 8888888880",
        "contactType": "Personal",
        "country": "IND",
        "relation": "Father",
        "email": "abc@gmail.com",
      })
    ],
    preferredServices: [
      PreferredService.fromJson({
        "id": 1,
        "name": "Testsss",
        "contactPerson": "Ram lakhan",
        "contactNumber": "91 8888888888",
        "preferredRank": 12,
        "ambulanceContact": null,
        "serviceType": "Hospital",
        "typeOfSupport": "BLS - Basic Life Support"
      }),
    ],
  );
  final baseURL = 'api';
  @override
  Future<Either<Failure, UserDetails>> fetchUserDetailsFromApi() async {
    //  API call here to fetch user details
    try {
      final cachedUserDetails = await _userDetailCache.getUserDetails();
      if (cachedUserDetails != null) {
        //returning catched details
        print('Cache User Details : => $cachedUserDetails');
        _userDetails = _userDetails.copyWith(user: cachedUserDetails);
        return Right(_userDetails);
      } else {
        // Return the fetched user details from api
        await _userDetailCache.saveUserDetails(_userDetails.user);
        print('Fetched User Details : => $_userDetails');
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
    required User user,
  }) async {
    try {
      final response = await httpClient.put<String>('$baseURL/users/${user.id}',
          data: user.toJson());

      if (response.statusCode == 200) {
        await _userDetailCache.saveUserDetails(user);
        print(response.data);
        _userDetails = _userDetails.copyWith(user: user);
        return Right(_userDetails);
      } else {
        return const Left(Failure.badResponse());
      }
    } on SocketException {
      return const Left(Failure.socketException());
    } on HiveError {
      return const Left(Failure.hiveError());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }
}
