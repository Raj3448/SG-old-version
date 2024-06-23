import 'package:freezed_annotation/freezed_annotation.dart';
part 'failure.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure.validationError(String message) = ValidationError;
  const factory Failure.socketError() = SocketError;
  const factory Failure.someThingWentWrong() = SomeThingWentWrong;
  const factory Failure.badResponse() = BadResponse;
  const factory Failure.hiveError() = HiveExceptionError;
}
