// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation, lines_longer_than_80_chars

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
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

  @override
  Future<Either<Failure, User>> updateUserDetails({
    required User user,
    String? imageId,
  }) async {
    try {
      var userData = user.toJson();

      var data = {
        'firstName': userData['firstName'],
        'lastName': userData['lastName'],
        'gender': userData['gender'],
        'dateOfBirth': userData['dateOfBirth'],
        'address': {
          'state': userData['address']['state'],
          'city': userData['address']['city'],
          'streetAddress': userData['address']['streetAddress'],
          'postalCode': userData['address']['postalCode'],
          'country': userData['address']['country'],
        },
      };
      if (userData['address']['id'] != -1) {
        data['address']['id'] = userData['address']['id'];
      }

      if (imageId != null) {
        data['profileImg'] = imageId;
      } else if (userData['profileImg'] == null) {
        data['profileImg'] = null;
      }

      final response =
          await httpClient.put<String>('/api/users/${user.id}', data: data);

      if (response.statusCode == 200) {
        /// WE should do single
        final updatedData = await fetchUserDetailsFromServer();
        return updatedData.fold(
          (l) => const Left(Failure.someThingWentWrong()),
          (r) => right(r),
        );
      } else {
        return const Left(Failure.someThingWentWrong());
      }
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        return const Left(Failure.socketError());
      }
      return const Left(Failure.someThingWentWrong());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }

  @override
  Future<Either<Failure, User>> fetchUserDetailsFromServer() async {
    try {
      final response = await httpClient.get('/api/users/me?populate=*');

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
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        return const Left(Failure.socketError());
      }
      return const Left(Failure.someThingWentWrong());
    } catch (error) {
      return const Left(Failure.badResponse());
    }
  }

  @override
  Future<Either<Failure, User>> updateUserDataWithProfileImg({
    required File fileImage,
    required User userInfo,
  }) async {
    try {
      var formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(
          fileImage.path,
        ),
      });
      final response = await httpClient.post(
        '/api/upload',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
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
      }if (response.statusCode == 413 && response.statusMessage == 'Request Entity Too Large'){
          return const Left(Failure.entityTooLargeError());
        }  else {
        return const Left(Failure.badResponse());
      }
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        return const Left(Failure.socketError());
      }
      return const Left(Failure.someThingWentWrong());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }

  @override
  Future<Either<Failure, SubscriptionModel>> fetchSubscriptions() async {
    try {
      final response = await httpClient.get('/api/all-subscription');

      if (response.statusCode == 200) {
        if (response.data != null) {
          final data = response.data;
          return Right(
            SubscriptionModel.fromJson(data as Map<String, dynamic>),
          );
        } else {
          return const Left(Failure.badResponse());
        }
      }
      return const Left(Failure.someThingWentWrong());
    } on SocketException {
      return const Left(Failure.socketError());
    } catch (error) {
      return const Left(Failure.badResponse());
    }
  }

  @override
  Future<Either<Failure, SubscriptionDetails>> getSubscriptionById({
    required int id,
  }) async {
    try {
      final response = await httpClient.get('/api/subscription-trackers/$id');

      if (response.statusCode == 200) {
        if (response.data != null) {
          final data = response.data['data'];
          return Right(
            SubscriptionDetails.fromJson(data as Map<String, dynamic>),
          );
        } else {
          return const Left(Failure.badResponse());
        }
      }
      return const Left(Failure.someThingWentWrong());
    } on SocketException {
      return const Left(Failure.socketError());
    } catch (error) {
      return const Left(Failure.badResponse());
    }
  }
}
