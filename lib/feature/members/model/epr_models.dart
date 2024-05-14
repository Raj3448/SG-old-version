import 'package:freezed_annotation/freezed_annotation.dart';

part 'epr_models.freezed.dart';
part 'epr_models.g.dart';


@freezed
class EmergencyContact with _$EmergencyContact {
    const factory EmergencyContact({
        required int id,
        required String contactPersonName,
        required String email,
        required String contactNumber,
        required String contactType,
        required String country,
        required dynamic relation,
        required dynamic contactDegree,
    }) = _EmergencyContact;

    factory EmergencyContact.fromJson(Map<String, dynamic> json) => _$EmergencyContactFromJson(json);
}

@freezed
class PreferredService with _$PreferredService {
    const factory PreferredService({
        required int id,
        required String name,
        required String contactPerson,
        required String contactNumber,
        required int preferredRank,
        required dynamic ambulanceContact,
        required String serviceType,
        required String typeOfSupport,
    }) = _PreferredService;

    factory PreferredService.fromJson(Map<String, dynamic> json) => _$PreferredServiceFromJson(json);
}

@freezed
class UserInsurance with _$UserInsurance {
    const factory UserInsurance({
        required int id,
        required String insuranceProvider,
        required String policyNumber,
        required String contactPerson,
        required String contactNumber,
        required DateTime expiryDate,
    }) = _UserInsurance;

    factory UserInsurance.fromJson(Map<String, dynamic> json) => _$UserInsuranceFromJson(json);
}