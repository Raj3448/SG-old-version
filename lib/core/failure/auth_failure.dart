import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_failure.freezed.dart';

@freezed
abstract class AuthFailure with _$AuthFailure {
  const factory AuthFailure.invalidPhoneNumber() = InvalidPhoneNumber;
  const factory AuthFailure.invalidEmail() = InvalidEmail;
  const factory AuthFailure.userNotFound() = UserNotFound;
  const factory AuthFailure.tooManyRequests() = TooManyRequests;
  const factory AuthFailure.otpExpired() = OtpExpired;
  const factory AuthFailure.otpInvalid() = OtpInvalid;
  const factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory AuthFailure.tokenExpired() = TokenExpired;
  const factory AuthFailure.networkError() = NetworkError;
  const factory AuthFailure.unknownError(String message) = UnknownError;
}
