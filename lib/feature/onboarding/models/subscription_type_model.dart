import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_type_model.freezed.dart';
part 'subscription_type_model.g.dart';

@freezed
class SubscriptionType with _$SubscriptionType {
  factory SubscriptionType({
    required String name,
    required String desc,
    required List<String> benefits,
  }) = _SubscriptionType;

  factory SubscriptionType.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionTypeFromJson(json);
}
