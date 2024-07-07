import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silver_genie/feature/book_services/model/payment_status_model.dart';
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

@freezed
class BookingServices with _$BookingServices {
    const factory BookingServices({
        required List<Service> services,
    }) = _BookingServices;
    factory BookingServices.fromJson(Map<String, dynamic> json) =>
      _$BookingServicesFromJson(json);
}

@freezed
class Service with _$Service {
    const factory Service({
        required int id,
        required String paymentStatus,
        required String status,
        required ServiceProduct product,
        required List<RequestedFor> requestedFor,
    }) = _Service;
    factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
}

@freezed
class ServiceProduct with _$ServiceProduct {
    const factory ServiceProduct({
        required int id,
        required String category,
        required String name,
        required String type,
    }) = _ServiceProduct;
    factory ServiceProduct.fromJson(Map<String, dynamic> json) =>
      _$ServiceProductFromJson(json);
}