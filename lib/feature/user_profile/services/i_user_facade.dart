import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
import 'package:silver_genie/feature/user_profile/services/user_failure.dart';

abstract class IUserFacades {
  Future<Either<UserFailure, UserDetails>> fetchUserDetailsFromApi();
  Future<Either<UserFailure,UserDetails>> updateUserDetails({@required UserDetails userDetails});
}
