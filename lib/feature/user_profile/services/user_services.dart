import 'dart:io';

import 'package:dio/dio.dart';
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
          id: 1,
          streetAddress:
              'No 10 Anna nagar 1 st street, near nehru park, chennai, TamilNadu 600028',
          country: 'India',
          state: 'Maharashtra',
          city: 'Pune',
          postalCode: '411065'),
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
  Future<Either<Failure, User>> fetchUserDetails() async {
    //  API call here to fetch user details
    try {
      final cachedUserDetails = await _userDetailCache.getUserDetails();
      if (cachedUserDetails != null) {
        //returning catched details
        print('Cache User Details : => $cachedUserDetails');
        _userDetails = _userDetails.copyWith(user: cachedUserDetails);
        return Right(_userDetails.user);
      } else {
        // Return the fetched user details from api
        await fetchUserDetailsFromServer();
        print('Fetched User Details : => $_userDetails');
        return Right(_userDetails.user);
      }
    } on SocketException {
      return const Left(Failure.socketException());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }

  @override
  Future<Either<Failure, User>> updateUserDetails(
      {required User user, String? imageId}) async {
    try {
      var userData = user.toJson();

      userData = {
        "firstName": userData['firstName'],
        "lastName": userData['lastName'],
        "gender": userData['gender'],
        "profileImg": userData['profileImg'],
        "dateOfBirth": userData['dateOfBirth'],
        "address": {
          "id": userData['address']['id'],
          "state": userData['address']['state'],
          "city": userData['address']['city'],
          "streetAddress": userData['address']['streetAddress'],
          "postalCode": userData['address']['postalCode'],
          "country": userData['address']['country']
        }
      };
      if (imageId != null) {
        userData.update('profileImg', (value) => imageId,
            ifAbsent: () => imageId);
      }
      final response = await httpClient
          .put<String>('/$baseURL/users/${user.id}', data: userData);

      if (response.statusCode == 200) {
        await fetchUserDetailsFromServer();
        return Right(_userDetails.user);
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

  @override
  Future<Either<Failure, User>> fetchUserDetailsFromServer() async {
    try {
      final response = await httpClient.get('/$baseURL/users/me?populate=*');

      if (response.statusCode == 200) {
        if (response.data != null) {
      
          final userdata = User.fromJson(response.data as Map<String, dynamic>);
          await _userDetailCache.saveUserDetails(userdata);
          _userDetails = _userDetails.copyWith(user: userdata);
          return Right(userdata);
        } else {
          return const Left(Failure.badResponse());
        }
      }
      return const Left(Failure.someThingWentWrong());
    } on SocketException {
      return const Left(Failure.socketException());
    } on HiveError {
      return const Left(Failure.hiveError());
    } catch (error) {
      return const Left(Failure.badResponse());
    }
  }

  @override
  Future<Either<Failure, User>> updateUserDataWithProfileImg(
      {required File fileImage, required User userInfo}) async {
    try {
      var formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(
          fileImage.path,
        )
      });
      final response = await httpClient.post('/$baseURL/upload',
          data: formData,
          options: Options(
            headers: {'Content-Type': 'multipart/form-data'},
          ));
      if (response.statusCode == 200) {
        final imageId = response.data[0]['id'];
        if (imageId != null) {
          await updateUserDetails(user: userInfo, imageId: imageId.toString());
          return Right(userInfo);
        } else {
          return const Left(Failure.badResponse());
        }
      } else {
        return const Left(Failure.badResponse());
      }
    } on SocketException {
      return const Left(Failure.socketException());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }
}
