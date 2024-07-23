// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silver_genie/feature/book_services/model/payment_status_model.dart';
part 'service_tracking_response.freezed.dart';
part 'service_tracking_response.g.dart';

@freezed
class ServiceTrackerResponse with _$ServiceTrackerResponse {
  const factory ServiceTrackerResponse({
    required int id,
    @JsonKey(name: 'razorpay_api_key') required String razorpayApiKey,
    @JsonKey(name: 'order_id') required String orderId,
    required double amount,
    required String memberName,
    required List<ServiceMetaDatum> metaData,
    required PriceDetails priceDetails,
  }) = _ServiceTrackerResponse;
  factory ServiceTrackerResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceTrackerResponseFromJson(json);
}

@freezed
class ServiceMetaDatum with _$ServiceMetaDatum {
  const factory ServiceMetaDatum({
    required int id,
    required String key,
    required String value,
    required bool private,
    required String type,
  }) = _ServiceMetaDatum;
  factory ServiceMetaDatum.fromJson(Map<String, dynamic> json) =>
      _$ServiceMetaDatumFromJson(json);
}
