import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:silver_genie/feature/members/model/epr_models.dart';

part 'user_details.freezed.dart';
part 'user_details.g.dart';

@freezed
class UserDetails with _$UserDetails {
  @JsonSerializable(explicitToJson: true)
  const factory UserDetails({
    required User user,
    required List<EmergencyContact> emergencyContacts,
    required List<UserInsurance> userInsurance,
    required List<PreferredService> preferredServices,
  }) = _UserDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) => _$UserDetailsFromJson(json);
}

@freezed
@HiveType(typeId: 20)
class User with _$User {
  @JsonSerializable(explicitToJson: true)
  const factory User({
    @HiveField(0) required int id,
    @HiveField(1) required String username,
    @HiveField(2) required String email,
    @HiveField(3) dynamic provider,
    @HiveField(4) required bool confirmed,
    @HiveField(5) required bool blocked,
    @HiveField(6) required String gender,
    @HiveField(7) required String phoneNumber,
    @HiveField(8) required DateTime dateOfBirth,
    @HiveField(9) @Default('Self') String relation,
    @HiveField(10) required String uniqueKey,
    @HiveField(11) required String firstName,
    @HiveField(12) required String lastName,
    @HiveField(13) dynamic userTags,
    @HiveField(14) required DateTime createdAt,
    @HiveField(15) required DateTime updatedAt,
    @HiveField(16) Address? address,
    @HiveField(17) ProfileImg? profileImg,
    @HiveField(18) @Default([]) List<UserDetails> members,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
@HiveType(typeId: 22)
class Address with _$Address {
  @JsonSerializable(explicitToJson: true)
  const factory Address({
    @HiveField(0) required int id,
    @HiveField(1) required String state,
    @HiveField(2) required String city,
    @HiveField(3) required String streetAddress,
    @HiveField(4) required String postalCode,
    @HiveField(5) required String country,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}

@freezed
@HiveType(typeId: 23)
class ProfileImg with _$ProfileImg {
  @JsonSerializable(explicitToJson: true)
  const factory ProfileImg({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) required int width,
    @HiveField(3) required int height,
    @HiveField(4) required Formats formats,
    @HiveField(5) required String ext,
    @HiveField(6) required String url,
    @HiveField(7) required DateTime createdAt,
    @HiveField(8) required DateTime updatedAt,
  }) = _ProfileImg;

  factory ProfileImg.fromJson(Map<String, dynamic> json) => _$ProfileImgFromJson(json);
}

@freezed
@HiveType(typeId: 24)
class Formats with _$Formats {
  @JsonSerializable(explicitToJson: true)
  const factory Formats({
    @HiveField(0) required Thumbnail thumbnail,
  }) = _Formats;

  factory Formats.fromJson(Map<String, dynamic> json) => _$FormatsFromJson(json);
}

@freezed
@HiveType(typeId: 25)
class Thumbnail with _$Thumbnail {
  @JsonSerializable(explicitToJson: true)
  const factory Thumbnail({
    @HiveField(0) required String ext,
    @HiveField(1) required String url,
    @HiveField(2) required int width,
    @HiveField(3) required int height,
  }) = _Thumbnail;

  factory Thumbnail.fromJson(Map<String, dynamic> json) => _$ThumbnailFromJson(json);
}