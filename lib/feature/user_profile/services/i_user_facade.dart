import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';

abstract class IUserFacades {
  Future<Either<Failure, User>> fetchUserDetails();
  Future<Either<Failure, User>> updateUserDetails({required User user,String? imageId});
  Future<Either<Failure, User>> fetchUserDetailsFromServer();
  Future<Either<Failure, User>> updateUserDataWithProfileImg({required File fileImage,required User userInfo });
}
