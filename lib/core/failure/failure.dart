import 'package:freezed_annotation/freezed_annotation.dart';
part 'failure.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure.socketException() = SocketException;
  const factory Failure.someThingWentWrong() = SomeThingWentWrong;
  const factory Failure.badResponse() = BadResponse;
}
