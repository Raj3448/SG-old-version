// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'member_model.freezed.dart';
// part 'member_model.g.dart';

// @freezed
// class Member with _$Member {
//   const factory Member({
//     required int id,
//     required String username,
//     required String email,
//     String? provider,
//     String? password,
//     String? resetPasswordToken,
//     String? confirmationToken,
//     required bool confirmed,
//     required bool blocked,
//     required String gender,
//     required String phoneNumber,
//     required DateTime dateOfBirth,
//     required String firstName,
//     required String lastName,
//     String? relation,
//     String? uniqueKey,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     List<String>? userTags,
//     Map<String, dynamic>? profileImg,
//     Map<String, dynamic>? userDetail,
//     Map<String, dynamic>? address,
//     Map<String, dynamic>? phr,
//   }) = _Member;

//   factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
// }

import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_model.freezed.dart';
part 'member_model.g.dart';

@freezed
class Member with _$Member {
  const factory Member({
    required int id,
    required String username,
    required String email,
    required String gender,
    required String phoneNumber,
    required DateTime dateOfBirth,
    required String firstName,
    required String lastName,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? relation,
    // String? address,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
