// To parse this JSON data, do
//
//     final emergencyServiceModel = emergencyServiceModelFromJson(jsonString);

// ignore_for_file: invalid_annotation_target

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'emergency_service_model.freezed.dart';
part 'emergency_service_model.g.dart';

EmergencyServiceModel emergencyServiceModelFromJson(String str) =>
    EmergencyServiceModel.fromJson(json.decode(str) as Map<String, dynamic>);

String emergencyServiceModelToJson(EmergencyServiceModel data) =>
    json.encode(data.toJson());

@freezed
class EmergencyServiceModel with _$EmergencyServiceModel {
  const factory EmergencyServiceModel({
    @JsonKey(name: 'defination') required String defination,
    @JsonKey(name: 'support') required Support support,
    @JsonKey(name: 'plansDescription') required String plansDescription,
    @JsonKey(name: 'plans') required List<Plan> plans,
  }) = _EmergencyServiceModel;

  factory EmergencyServiceModel.fromJson(Map<String, dynamic> json) =>
      _$EmergencyServiceModelFromJson(json);
}

@freezed
class Plan with _$Plan {
  const factory Plan({
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'duration') required String duration,
    @JsonKey(name: 'descrip') required String descrip,
    @JsonKey(name: 'amount') required double amount,
    @JsonKey(name: 'discountamount') required double discountamount,
  }) = _Plan;

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
}

@freezed
class Support with _$Support {
  const factory Support({
    @JsonKey(name: 'preparedness') required String preparedness,
    @JsonKey(name: 'Hospital') required String hospital,
    @JsonKey(name: 'postDischarge') required String postDischarge,
    @JsonKey(name: 'healthMonitor') required String healthMonitor,
    @JsonKey(name: 'genieCare') required String genieCare,
  }) = _Support;

  factory Support.fromJson(Map<String, dynamic> json) =>
      _$SupportFromJson(json);
}
