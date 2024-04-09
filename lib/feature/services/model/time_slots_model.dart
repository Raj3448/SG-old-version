// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slots_model.freezed.dart';
part 'time_slots_model.g.dart';

@freezed
class TimeSlotsModel with _$TimeSlotsModel {
  const factory TimeSlotsModel({
    @JsonKey(name: 'time_slot') required String timeSlot,
  }) = _TimeSlotsModel;

  factory TimeSlotsModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotsModelFromJson(json);
}
