import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
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

  final baseURL = 'api';

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
        /// WE should do single
        final updatedData = await fetchUserDetailsFromServer();
        return updatedData.fold(
            (l) => const Left(Failure.someThingWentWrong()), (r) => right(r));
      } else {
        return const Left(Failure.someThingWentWrong());
      }
    } on SocketException {
      return const Left(Failure.socketException());
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
          return Right(userdata);
        } else {
          return const Left(Failure.badResponse());
        }
      }
      return const Left(Failure.someThingWentWrong());
    } on SocketException {
      return const Left(Failure.socketException());
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
          return await updateUserDetails(
            user: userInfo,
            imageId: imageId.toString(),
          );
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
