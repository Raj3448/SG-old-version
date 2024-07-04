import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silver_genie/feature/book_services/model/service_tracking_response.dart';

part 'payment_status_model.freezed.dart';
part 'payment_status_model.g.dart';

@freezed
class PaymentStatusModel with _$PaymentStatusModel {
  const factory PaymentStatusModel({
    required int id,
    required String paymentStatus,
    required String status,
    required int amount,
    required int priceId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime requestedAt,
    required dynamic razorpayOrderId,
    required List<ServiceMetaDatum> metadata,
    required Product product,
    required RequestedBy requestedBy,
    required List<RequestedFor> requestedFor,
  }) = _PaymentStatusModel;
  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentStatusModelFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String category,
    required String name,
    required String type,
  }) = _Product;
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
class RequestedBy with _$RequestedBy {
  const factory RequestedBy({
    required int id,
  }) = _RequestedBy;
  factory RequestedBy.fromJson(Map<String, dynamic> json) =>
      _$RequestedByFromJson(json);
}

@freezed
class RequestedFor with _$RequestedFor {
  const factory RequestedFor({
    required int id,
    required String firstName,
    required String lastName,
    required String gender,
    required String relation,
    required dynamic profileImg,
  }) = _RequestedFor;
  factory RequestedFor.fromJson(Map<String, dynamic> json) =>
      _$RequestedForFromJson(json);
}
