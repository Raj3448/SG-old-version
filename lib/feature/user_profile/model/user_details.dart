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

    factory UserDetails.fromJson(Map<String, dynamic> json) => _$UserDetailsFromJson(json);
}


@freezed
class User with _$User {
    const factory User({
        required int id,
        required String username,
        required String email,
        required bool confirmed,
        required bool blocked,
        required String gender,
        required String phoneNumber,
        required DateTime dateOfBirth,
        required dynamic relation,
        required String uniqueKey,
        required String firstName,
        required String lastName,
        required Address address,
        required dynamic userTags,
        required DateTime createdAt,
        required DateTime updatedAt,
    }) = _User;

    factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class Address with _$Address {
    const factory Address({
        required String city,
        required String state,
        required String streetAddress,
        required String postalCode,
        required String country
    }) = _Address;

    factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}