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
    required String contactPersonName,
    required String email,
    required String contactNumber,
    @Default('') String? contactType,
    @Default('') String? country,
    String? relation,
    @Default('') dynamic contactDegree,
  }) = _EmergencyContact;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactFromJson(json);
}

@freezed
class PreferredService with _$PreferredService {
  const factory PreferredService({
    required int id,
    required String name,
    required String contactPerson,
    required String contactNumber,
    int? preferredRank,
    String? ambulanceContact,
    @Default('Hospital') String? serviceType,
  }) = _PreferredService;

  factory PreferredService.fromJson(Map<String, dynamic> json) =>
      _$PreferredServiceFromJson(json);
}

@freezed
class UserInsurance with _$UserInsurance {
  const factory UserInsurance({
    required int id,
    required String insuranceProvider,
    String? policyNumber,
    required String contactPerson,
    required String contactNumber,
    
  }) = _UserInsurance;

  factory UserInsurance.fromJson(Map<String, dynamic> json) =>
      _$UserInsuranceFromJson(json);
}
