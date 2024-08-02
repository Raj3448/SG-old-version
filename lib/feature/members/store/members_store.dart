// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/utils/country_list.dart';
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
  List<Member> get familyMembers => members
      .where((member) => member.isFamilyMember ?? false == true)
      .toList();

  @action
  Member? findMemberById(int id) {
    return familyMembers.firstWhere((member) => member.id == id);
  }

  @computed
  int? get activeMemberId => selectedMemberId ?? familyMembers.firstOrNull?.id;

  @computed
  Member? get activeMember => activeMemberId != null
      ? familyMembers.firstWhere((member) => member.id == activeMemberId)
      : null;

  @observable
  bool isActive = true;

  @observable
  int? selectedMemberId;

  @observable
  bool isLoading = false;

  @observable
  bool isAddOrEditLoading = false;

  @observable
  bool isRefreshing = false;

  @observable
  bool initialLoaded = false;

  @observable
  String? addOrEditMemberFailure;

  @observable
  String? addOrEditMemberSuccessful;

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
  void refresh() {
    if (!initialLoaded) {
      return;
    }
    isRefreshing = true;
    try {
      memberService.getMembers().then((membersOrFailure) {
        membersOrFailure.fold(
          (failure) {},
          (membersList) {
            members = membersList;
            errorMessage = null;
          },
        );
      });
    } finally {
      isRefreshing = false;
    }
  }

  @action
  void updateMember({
    required int id,
    required Map<String, dynamic> updatedData,
  }) {
    isAddOrEditLoading = true;
    memberService.updateMember(id.toString(), updatedData, null).then((value) {
      value.fold((l) {
        l.maybeMap(
          socketExceptionError: (value) {
            addOrEditMemberFailure = 'No internet connection';
          },
          orElse: () {
            addOrEditMemberFailure = '$value';
          },
        );
      }, (r) {
        addOrEditMemberSuccessful = 'Family Member Updated Successfully';
      });
      isAddOrEditLoading = false;
    });
  }

  @action
  void updateMemberDataWithProfileImg({
    required String id,
    required File fileImage,
    required Map<String, dynamic> memberInstance,
  }) {
    isAddOrEditLoading = true;
    memberService
        .updateMemberDataWithProfileImg(
      id: id,
      fileImage: fileImage,
      memberInfo: memberInstance,
    )
        .then((value) {
      value.fold((l) {
        l.maybeMap(
          socketExceptionError: (value) {
            addOrEditMemberFailure = 'No internet connection';
            return null;
          },
          orElse: () {
            addOrEditMemberFailure = '$value';
            return null;
          },
        );
      }, (r) {
        addOrEditMemberSuccessful = 'Family Member Updated Successfully';
      });
      isAddOrEditLoading = false;
    });
  }

  Member? memberById(int? id) {
    if (id == null) return null;

    for (final member in familyMembers) {
      if (member.id == id) {
        return member;
      }
    }
    return null;
  }

  @action
  void addNewFamilyMember({
    required Map<String, dynamic> memberData,
    File? fileImage,
  }) {
    isAddOrEditLoading = true;
    fileImage != null
        ? memberService
            .addMemberDataWithProfileImg(
            fileImage: fileImage,
            memberInfo: memberData,
          )
            .then((value) {
            value.fold((l) {
              l.maybeMap(
                socketExceptionError: (value) {
                  addOrEditMemberFailure = 'No internet connection';
                },
                validationError: (value) {
                  addOrEditMemberFailure =
                      _handleValidationError(value.toString());
                },
                orElse: () {
                  addOrEditMemberFailure = 'Something went wrong';
                },
              );
            }, (r) {
              addOrEditMemberSuccessful = 'New Family Member Added';
            });
            isAddOrEditLoading = false;
          })
        : memberService
            .addMember(
            memberData,
            null,
          )
            .then((value) {
            value.fold((l) {
              l.maybeMap(
                socketExceptionError: (value) {
                  addOrEditMemberFailure = 'No internet connection';
                },
                validationError: (value) {
                  addOrEditMemberFailure =
                      _handleValidationError(value.toString());
                },
                orElse: () {
                  addOrEditMemberFailure = 'Something went wrong';
                },
              );
            }, (r) {
              addOrEditMemberSuccessful = 'New Family Member Added';
            });
            isAddOrEditLoading = false;
          });
  }

  String _handleValidationError(String message) {
    if (message.contains('phoneNumber')) {
      return 'Phone number already in use!';
    } else if (message.contains('email')) {
      return 'Email already in use!';
    } else {
      return 'Something went wrong: $message';
    }
  }

  void clear() {
    members = [];
    errorMessage = null;
    selectedIndex = 0;
    selectedMemberId = null;
    isActive = false;
    isLoading = false;
    isRefreshing = false;
    initialLoaded = false;
    addOrEditMemberFailure = null;
    addOrEditMemberSuccessful = null;
    isAddOrEditLoading = false;
  }
}

extension MemberExtension on Member {
  String get name => [firstName, lastName].join(' ').trim();
  String get fullAddress {
    final address = this.address;
    if (address == null) {
      return '';
    }

    return [
      [
        address.streetAddress,
        address.city,
        address.state,
        countries
            .firstWhere(
              (element) => element.isoCode == address.country,
              orElse: () => Country('', address.country),
            )
            .name,
      ].where((part) => part.isNotEmpty).join(', '),
      address.postalCode,
    ].where((part) => part.isNotEmpty).join(' - ');
  }
}
