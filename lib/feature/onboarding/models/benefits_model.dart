import 'package:freezed_annotation/freezed_annotation.dart';

part 'benefits_model.freezed.dart';
part 'benefits_model.g.dart';

@freezed
class Benefits with _$Benefits {
  factory Benefits({
    required String name,
    required String desc,
  }) = _Benefits;

  factory Benefits.fromJson(Map<String, dynamic> json) =>
      _$BenefitsFromJson(json);
}
