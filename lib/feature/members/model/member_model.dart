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
import 'package:silver_genie/feature/user_profile/model/user_details.dart';

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
    ProfileImg? profileImg,
    String? relation,
    Address? address,
    PhrModel? phrModel,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}

@freezed
class PhrModel with _$PhrModel {
  @JsonSerializable(createToJson: true)
  const factory PhrModel({
    required int id,
    required String firstName,
    required String lastName,
    required int age,
    required String email,
    required String gender,
    required String bloodGroup,
    required bool downloadPhr,
    required String uniqueKey,
    required String additionalInformation,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PhrModel;

  factory PhrModel.fromJson(Map<String, dynamic> json) => _$PhrModelFromJson(json);
}
