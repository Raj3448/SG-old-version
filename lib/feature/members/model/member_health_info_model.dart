import 'package:freezed_annotation/freezed_annotation.dart';
part 'member_health_info_model.freezed.dart';
part 'member_health_info_model.g.dart';

@freezed
class MemberHealthInfo with _$MemberHealthInfo {
  const factory MemberHealthInfo({
    required String name,
    required String relation,
    required String age,
    required String bloodPressure,
    required String bloodOxygen,
    required String heartRate,
    required String fastGlucose,
    required String lastUpdated,
    required String phrUrl,
    required String eprUrl,
  }) = _MemberHealthInfo;

  factory MemberHealthInfo.fromJson(Map<String, dynamic> json) =>
      _$MemberHealthInfoFromJson(json);
}
