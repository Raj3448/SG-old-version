import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silver_genie/feature/members/model/epr_models.dart';

part 'user_details.freezed.dart';
part 'user_details.g.dart';

@freezed
class UserDetails with _$UserDetails {
  const factory UserDetails({
    required User user,
    required List<EmergencyContact> emergencyContacts,
    required List<UserInsurance> userInsurance,
    required List<PreferredService> preferredServices,
  }) = _UserDetails;

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);
}

@JsonSerializable(
  createFactory: true,
)
class User {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "username")
  final String username;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "confirmed")
  final bool confirmed;
  @JsonKey(name: "blocked")
  final bool blocked;
  @JsonKey(name: "gender")
  final String gender;
  @JsonKey(name: "phoneNumber")
  final String phoneNumber;
  @JsonKey(name: "dateOfBirth")
  final DateTime dateOfBirth;
  @JsonKey(name: "relation")
  String? relation;
  @JsonKey(name: "uniqueKey")
  final String uniqueKey;
  @JsonKey(name: "firstName")
  final String firstName;
  @JsonKey(name: "lastName")
  final String lastName;
  @JsonKey(name: "userTags")
  final dynamic userTags;
  @JsonKey(name: "createdAt")
  final DateTime createdAt;
  @JsonKey(name: "updatedAt")
  final DateTime updatedAt;
  @JsonKey(name: "address")
  Address? address = Address(
      id: 0,
      state: '',
      city: '',
      streetAddress: '',
      postalCode: '',
      country: '');

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.confirmed,
    required this.blocked,
    required this.gender,
    required this.phoneNumber,
    required this.dateOfBirth,
    this.relation,
    required this.uniqueKey,
    required this.firstName,
    required this.lastName,
    required this.userTags,
    required this.createdAt,
    required this.updatedAt,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    int? id,
    String? username,
    String? email,
    bool? confirmed,
    bool? blocked,
    String? gender,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? relation,
    String? uniqueKey,
    String? firstName,
    String? lastName,
    dynamic userTags,
    DateTime? createdAt,
    DateTime? updatedAt,
    Address? address,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      confirmed: confirmed ?? this.confirmed,
      blocked: blocked ?? this.blocked,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      relation: relation ?? this.relation,
      uniqueKey: uniqueKey ?? this.uniqueKey,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userTags: userTags ?? this.userTags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      address: address ?? this.address,
    );
  }
}

@JsonSerializable()
class Address {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "state")
  final String state;
  @JsonKey(name: "city")
  final String city;
  @JsonKey(name: "streetAddress")
  final String streetAddress;
  @JsonKey(name: "postalCode")
  final String postalCode;
  @JsonKey(name: "country")
  final String country;

  Address({
    required this.id,
    required this.state,
    required this.city,
    required this.streetAddress,
    required this.postalCode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
