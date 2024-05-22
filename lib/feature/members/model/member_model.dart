import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_model.freezed.dart';
part 'member_model.g.dart';

@freezed
class Member with _$Member {
  const factory Member({
    required int id,
    required String username,
    required String email,
    required String gender,
    required String phoneNumber,
    required DateTime dateOfBirth,
    required String firstName,
    required String lastName,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? relation,
    // String? address,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
