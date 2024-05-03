// To parse this JSON data, do
//
//     final subscriptionMemberModel = subscriptionMemberModelFromJson(jsonString);

// ignore_for_file: invalid_annotation_target, lines_longer_than_80_chars

import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_member_model.freezed.dart';
part 'subscription_member_model.g.dart';

@freezed
class SubscriptionMemberModel with _$SubscriptionMemberModel {
  const factory SubscriptionMemberModel({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'relation') required String relation,
    @JsonKey(name: 'age') required int age,
    @JsonKey(name: 'plan') required String plan,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'planEndsDate') required String planEndsDate,
  }) = _SubscriptionMemberModel;

  factory SubscriptionMemberModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionMemberModelFromJson(json);
}
