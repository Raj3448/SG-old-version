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

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';

part 'member_model.freezed.dart';
part 'member_model.g.dart';

@freezed
class Member with _$Member {
  const factory Member({
    required int id,
    required String username,
    required String email,
    required dynamic provider,
    required dynamic password,
    required dynamic resetPasswordToken,
    required dynamic confirmationToken,
    required bool confirmed,
    required bool blocked,
    required String gender,
    required String phoneNumber,
    required DateTime dateOfBirth,
    required String uniqueKey,
    required String firstName,
    required String lastName,
    required dynamic userTags,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String? fcm,
    @JsonKey(name: 'care_coach') required CareCoach? careCoach,
    @JsonKey(name: 'user_detail') required UserDetail? userDetail,
    ProfileImg? profileImg,
    Address? address,
    @Default([]) List<SubscriptionDetails>? subscriptions,
    @Default('Self') String relation,
    @Default(false) bool? isFamilyMember,
    @JsonKey(name: 'phr') PhrModel? phrModel,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}

@freezed
class UserDetail with _$UserDetail {
  const factory UserDetail({
    required int id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserDetail;

  factory UserDetail.fromJson(Map<String, dynamic> json) =>
      _$UserDetailFromJson(json);
}

@freezed
class CareCoach with _$CareCoach {
  const factory CareCoach({
    required int id,
    required String firstName,
    required String? lastName,
    required String contactNo,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime publishedAt,
    ProfileImg? profileImg,
  }) = _CareCoach;

  factory CareCoach.fromJson(Map<String, dynamic> json) =>
      _$CareCoachFromJson(json);
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
    List<DiagnosedService>? diagnosedServices,
  }) = _PhrModel;

  factory PhrModel.fromJson(Map<String, dynamic> json) =>
      _$PhrModelFromJson(json);
}

@freezed
class DiagnosedService with _$DiagnosedService {
  const factory DiagnosedService({
    required int id,
    required DateTime diagnosedDate,
    required String description,
    required String value,
    required bool publish,
  }) = _DiagnosedService;

  factory DiagnosedService.fromJson(Map<String, dynamic> json) =>
      _$DiagnosedServiceFromJson(json);
}
