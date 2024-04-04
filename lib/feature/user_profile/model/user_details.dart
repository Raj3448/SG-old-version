import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'user_details.g.dart';

UserDetails userDetailsFromJson(String str) =>
    UserDetails.fromJson(json.decode(str) as Map<String, dynamic>);

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

@JsonSerializable()
class UserDetails {
  @JsonKey(name: "fullname")
  final String fullname;
  @JsonKey(name: "gender")
  final String gender;
  @JsonKey(name: "dateBirth")
  final String dateBirth;
  @JsonKey(name: "mobileNum")
  @Default("+91 1234567890")
  final String mobileNum;
  @JsonKey(name: "emailId")
  @Default("example@gmail.com")
  final String emailId;
  @JsonKey(name: "address")
  final String address;
  @JsonKey(name: "country")
  final String country;
  @JsonKey(name: "state")
  final String state;
  @JsonKey(name: "city")
  final String city;
  @JsonKey(name: "postalCode")
  final int postalCode;

  UserDetails({
    required this.fullname,
    required this.gender,
    required this.dateBirth,
    required this.mobileNum,
    required this.emailId,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.postalCode,
  });

  UserDetails copyWith({
    String? fullname,
    String? gender,
    String? dateBirth,
    String? mobileNum,
    String? emailId,
    String? address,
    String? country,
    String? state,
    String? city,
    int? postalCode,
  }) =>
      UserDetails(
        fullname: fullname ?? this.fullname,
        gender: gender ?? this.gender,
        dateBirth: dateBirth ?? this.dateBirth,
        mobileNum: mobileNum ?? this.mobileNum,
        emailId: emailId ?? this.emailId,
        address: address ?? this.address,
        country: country ?? this.country,
        state: state ?? this.state,
        city: city ?? this.city,
        postalCode: postalCode ?? this.postalCode,
      );

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsToJson(this);
}
