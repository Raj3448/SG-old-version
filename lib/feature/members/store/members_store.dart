// ignore_for_file: library_private_types_in_public_api

import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/repo/member_service.dart';
part 'members_store.g.dart';

class MembersStore = _MembersStoreBase with _$MembersStore;

abstract class _MembersStoreBase with Store {
  _MembersStoreBase(this.memberService);

  final MemberService memberService;

  @observable
  List<Member> members = [];

  @observable
  Either<Failure, void>? failure;

  @observable
  String? errorMessage;

  @action
  Future<Either<Failure, List<Member>>> fetchMembers() async {
    try {
      final membersOrFailure = await memberService.getMembers();
      return membersOrFailure.fold(
        (failure) {
          errorMessage = 'failure';
          return Left(failure);
        },
        (membersList) {
          members = membersList;
          errorMessage = null;
          return Right(membersList);
        },
      );
    } catch (e) {
      errorMessage = 'An unexpected error occurred';
      return const Left(Failure.someThingWentWrong());
    }
  }
}
