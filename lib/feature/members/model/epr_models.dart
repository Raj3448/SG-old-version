// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'epr_models.freezed.dart';
part 'epr_models.g.dart';

@freezed
class EprDataModel with _$EprDataModel {
  // Private constructor

  const factory EprDataModel({
    required int id,
    @Default([]) List<EmergencyContact> emergencyContacts,
    @JsonKey(name: 'UserInsurance')
    @Default([])
    List<UserInsurance> userInsurance,
    @Default([]) List<PreferredService> preferredServices,
  }) = _EprDataModel;
  factory EprDataModel.fromJson(Map<String, dynamic> json) =>
      _$EprDataModelFromJson(json);
  const EprDataModel._();

  List<PreferredService> get getPreferredAmbulace =>
      preferredServices.where((e) => e.serviceType == 'Ambulance').toList();
  List<PreferredService> get getPreferredHospital =>
      preferredServices.where((e) => e.serviceType == 'Hospital').toList();
}

@freezed
class EmergencyContact with _$EmergencyContact {
  const factory EmergencyContact({
    required int id,
    String? contactPersonName,
    String? email,
    String? contactNumber,
    String? contactType,
    String? country,
    String? relation,
    dynamic contactDegree,
  }) = _EmergencyContact;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactFromJson(json);
}

@freezed
class PreferredService with _$PreferredService {
  const factory PreferredService({
    required int id,
    String? name,
    String? contactPerson,
    String? contactNumber,
    int? preferredRank,
    String? ambulanceContact,
    String? serviceType,
    String? typeOfSupport,
  }) = _PreferredService;

  factory PreferredService.fromJson(Map<String, dynamic> json) =>
      _$PreferredServiceFromJson(json);
}

@freezed
class UserInsurance with _$UserInsurance {
  const factory UserInsurance({
    required int id,
    String? insuranceProvider,
    String? policyNumber,
    String? contactPerson,
    String? contactNumber,
    DateTime? expiryDate,
  }) = _UserInsurance;

  factory UserInsurance.fromJson(Map<String, dynamic> json) =>
      _$UserInsuranceFromJson(json);
}
