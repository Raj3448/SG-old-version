import 'package:freezed_annotation/freezed_annotation.dart';
part 'booking_service_model.g.dart';
part 'booking_service_model.freezed.dart';

@freezed
class BookingServiceModel with _$BookingServiceModel {
  const factory BookingServiceModel({
    required int id,
    required String status,
    required String serviceName,
    required String memberName,
    required DateTime requestedDate,
    DateTime? completedDate,
  }) = _BookingServiceModel;

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) =>
      _$BookingServiceModelFromJson(json);
}