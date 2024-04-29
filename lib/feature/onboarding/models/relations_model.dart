import 'package:freezed_annotation/freezed_annotation.dart';

part 'relations_model.freezed.dart';
part 'relations_model.g.dart';

@freezed
class Relations with _$Relations {
  factory Relations({
    required int id,
    required String name,
    required int rank,
    required bool active,
  }) = _Relations;

  factory Relations.fromJson(Map<String, dynamic> json) =>
      _$RelationsFromJson(json);
}
