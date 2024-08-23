// ignore_for_file: lines_longer_than_80_chars, invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silver_genie/feature/home/model/home_page_model.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required List<AppNotifications> data,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

@freezed
class AppNotifications with _$AppNotifications {
  const factory AppNotifications({
    required int id,
    @JsonKey(name: 'attributes')
    required NotificationMetaData notificationMetaData,
  }) = _AppNotifications;
  factory AppNotifications.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationsFromJson(json);
}

@freezed
class NotificationMetaData with _$NotificationMetaData {
  const factory NotificationMetaData({
    required DateTime createdAt,
    required String title,
    required String message,
    required bool read,
    required String type,
    required DateTime updatedAt,
    required String actionType,
    required String? actionUrl,
    required BannerImage image,
    required List<AdditionalDatum> additionalData,
    @Default(null) DateTime? readAt,
  }) = _NotificationMetaData;

  factory NotificationMetaData.fromJson(Map<String, dynamic> json) =>
      _$NotificationMetaDataFromJson(json);
}

@freezed
class AdditionalDatum with _$AdditionalDatum {
  const factory AdditionalDatum({
    required int id,
    required String key,
    required String value,
  }) = _AdditionalDatum;
  factory AdditionalDatum.fromJson(Map<String, dynamic> json) =>
      _$AdditionalDatumFromJson(json);
}
