import 'package:freezed_annotation/freezed_annotation.dart';
part 'service_tracking_response.freezed.dart';
part 'service_tracking_response.g.dart';

@freezed
class ServiceTrackerResponse with _$ServiceTrackerResponse {
    const factory ServiceTrackerResponse({
        @JsonKey(name: 'razorpay_api_key') required String razorpayApiKey,
        @JsonKey(name: 'order_id') required String orderId,
        required int amount,
        required String memberName,
        required List<ServiceMetaDatum> metaData,
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
