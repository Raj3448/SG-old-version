// ignore_for_file: library_private_types_in_public_api

import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/failure/member_services_failure.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/repo/member_service.dart';
part 'members_store.g.dart';

class MembersStore = _MembersStoreBase with _$MembersStore;

abstract class _MembersStoreBase with Store {
  _MembersStoreBase(this.memberService);

  final MemberServices memberService;

  @observable
  List<Member> members = [];

  @observable
  String? errorMessage;

  @observable
  int selectedIndex = 0;

  @computed
  int? get activeMemberId =>
      selectedMemberId != null ? selectedMemberId : members.firstOrNull?.id;

  @computed
  Member? get activeMember => activeMemberId != null
      ? members.firstWhere((member) => member.id == activeMemberId)
      : null;

  @observable
  bool isActive = true;

  @observable
  int? selectedMemberId;

  @observable
  bool isLoading = false;

  @observable
  bool initialLoaded = false;

  @action
  void selectMember(int memberId) {
    selectedMemberId = memberId;
  }

  @action
  Future<void> fetchMembers() async {
    isLoading = true;
    try {
      final membersOrFailure = await memberService.getMembers();
      membersOrFailure.fold(
        (failure) {
          errorMessage = 'failure';
          isLoading = false;
        },
        (membersList) {
          members = membersList;
          errorMessage = null;
          isLoading = false;
        },
      );
    } catch (e) {
      errorMessage = 'An unexpected error occurred';
      isLoading = false;
    }
  }

  @action
  Future<void> init() async {
    if (initialLoaded) {
      return;
    }
    isLoading = true;
    try {
      final membersOrFailure = await memberService.getMembers();
      membersOrFailure.fold(
        (failure) {
          errorMessage = 'failure';
          isLoading = false;
        },
        (membersList) {
          members = membersList;
          errorMessage = null;
          isLoading = false;
        },
      );
    } catch (e) {
      errorMessage = 'An unexpected error occurred';
      isLoading = false;
    } finally {
      initialLoaded = true;
    }
  }

  @action
  Future<Future<Either<MemberServiceFailure, Member>>> updateMember(
    int id,
    Map<String, dynamic> updatedData,
  ) async {
    return memberService.updateMember(id, updatedData);
  }
}
