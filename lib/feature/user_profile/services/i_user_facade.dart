import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';

abstract class IUserFacades {
  Future<Either<Failure, UserDetails>> fetchUserDetailsFromApi();
  Future<Either<Failure,UserDetails>> updateUserDetails({required User user});
}
