import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
part 'master_data_model.g.dart';
part 'master_data_model.freezed.dart';

@freezed
@HiveType(typeId: 26)
class MasterDataModel with _$MasterDataModel {
    @JsonSerializable(explicitToJson: true)
    const factory MasterDataModel({
        @HiveField(1) required int id,
        @HiveField(2) @JsonKey(name:'attributes') required MasterData masterData,
    }) = _MasterDataModel;
    factory MasterDataModel.fromJson(Map<String, dynamic> json) =>
      _$MasterDataModelFromJson(json);
}

@freezed
@HiveType(typeId:27)
class MasterData with _$MasterData {
    @JsonSerializable(explicitToJson: true)
    const factory MasterData({
        @HiveField(1) required DateTime createdAt,
        @HiveField(2) required DateTime updatedAt,
        @HiveField(3) required ContactUs contactUs,
        @HiveField(4) required EmergencyHelpline emergencyHelpline,
    }) = _MasterData;
    factory MasterData.fromJson(Map<String, dynamic> json) =>
      _$MasterDataFromJson(json);
}

@freezed
@HiveType(typeId: 28)
class ContactUs with _$ContactUs {
    @JsonSerializable(explicitToJson: true)
    const factory ContactUs({
        @HiveField(1) required int id,
        @HiveField(2) required String contactNumber,
    }) = _ContactUs;

    factory ContactUs.fromJson(Map<String, dynamic> json) =>
      _$ContactUsFromJson(json);
}

@freezed
@HiveType(typeId: 29)
class EmergencyHelpline with _$EmergencyHelpline {
    @JsonSerializable(explicitToJson: true)
    const factory EmergencyHelpline({
        @HiveField(1) required int id,
        @HiveField(2) required String contactNumber,
        @HiveField(3) @Default(null) String? label,
        @HiveField(4) @Default(null) String? message,
    }) = _EmergencyHelpline;

    factory EmergencyHelpline.fromJson(Map<String, dynamic> json) =>
      _$EmergencyHelplineFromJson(json);
}