import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
    const factory NotificationModel({
        required String title,
        required String description,
        required DateTime datetime,
        String? imageUrl,
    }) = _NotificationModel;

    factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
}
