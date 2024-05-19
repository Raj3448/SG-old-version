import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_model.freezed.dart';
part 'member_model.g.dart';

@freezed
class Member with _$Member {
  const factory Member({
    required int id,
    required String username,
    required String email,
    String? provider,
    String? password,
    String? resetPasswordToken,
    String? confirmationToken,
    required bool confirmed,
    required bool blocked,
    required String gender,
    required String phoneNumber,
    required String dateOfBirth,
    String? relation,
    required String uniqueKey,
    required String firstName,
    required String lastName,
    dynamic userTags, // Assuming userTags can be any type, adjust as necessary
    required String createdAt,
    required String updatedAt,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
