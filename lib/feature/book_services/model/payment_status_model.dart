import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silver_genie/feature/book_services/model/service_tracking_response.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';

part 'payment_status_model.freezed.dart';
part 'payment_status_model.g.dart';

@freezed
class ServicePaymentStatusModel with _$ServicePaymentStatusModel {
  const factory ServicePaymentStatusModel({
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
    required PriceDetails priceDetails,
  }) = _ServicePaymentStatusModel;
  factory ServicePaymentStatusModel.fromJson(Map<String, dynamic> json) =>
      _$ServicePaymentStatusModelFromJson(json);
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
    @Default(null) ProfileImg? profileImg,
  }) = _RequestedFor;
  factory RequestedFor.fromJson(Map<String, dynamic> json) =>
      _$RequestedForFromJson(json);
}

@freezed
class PriceDetails with _$PriceDetails {
  const factory PriceDetails({
    required int id,
    required int totalAmount,
    required int subTotal,
    required int totalTax,
    required int totalDiscount,
    required List<ProductMetaData> products,
  }) = _PriceDetails;
  factory PriceDetails.fromJson(Map<String, dynamic> json) =>
      _$PriceDetailsFromJson(json);
}

@freezed
class ProductMetaData with _$ProductMetaData {
  const factory ProductMetaData({
    required int id,
    required String productId,
    required String displayName,
    required String productName,
    required int price,
    required String priceId,
    required int quantity,
  }) = _Products;
  factory ProductMetaData.fromJson(Map<String, dynamic> json) =>
      _$ProductMetaDataFromJson(json);
}
