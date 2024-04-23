import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_failure.freezed.dart';

@freezed
abstract class UserFailure with _$UserFailure {
  const factory UserFailure.socketException() = SocketException;
  const factory UserFailure.someThingWentWrong() = SomeThingWentWrong;
  const factory UserFailure.badResponse() = BadResponse;
}
