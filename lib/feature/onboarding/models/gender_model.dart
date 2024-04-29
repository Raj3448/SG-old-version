import 'package:freezed_annotation/freezed_annotation.dart';

part 'gender_model.freezed.dart';
part 'gender_model.g.dart';

@freezed
class Gender with _$Gender {
  factory Gender({
    required String name,
    required int id,
  }) = _Gender;

  factory Gender.fromJson(Map<String, dynamic> json) => _$GenderFromJson(json);
}
