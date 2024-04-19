import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';
part 'user_failure_or_success.freezed.dart';

@freezed
abstract class UserFailure with _$UserFailure {
  const factory UserFailure.socketException() = SocketException;
  const factory UserFailure.someThingWentWrong() = SomeThingWentWrong;
  const factory UserFailure.badResponse() = BadResponse;
}

@freezed
abstract class UserSuccess with _$UserSuccess {
  const factory UserSuccess.success(UserDetails userDetails) = Success;
}
