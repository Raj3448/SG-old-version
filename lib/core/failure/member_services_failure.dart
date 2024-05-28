import 'package:freezed_annotation/freezed_annotation.dart';
part 'member_services_failure.freezed.dart';

@freezed
abstract class MemberServiceFailure with _$MemberServiceFailure {
  const factory MemberServiceFailure.eprDataFetchError() = EprDataFetchError;
  const factory MemberServiceFailure.memberDetailsEditError() =
      MemberDetailsEditError;
  const factory MemberServiceFailure.fetchMemberInfoError() =
      FetchMemberInfoErro;
  const factory MemberServiceFailure.badResponse() = BadResponse;
  const factory MemberServiceFailure.addMemberError() = AddMemberError;
  const factory MemberServiceFailure.socketExceptionError() = SocketExceptionError;
  const factory MemberServiceFailure.validationError(String message) =
      ValidationError;
  const factory MemberServiceFailure.memberDontHaveEPRInfo() =
      MemberDontHaveEPRInfo;
  const factory MemberServiceFailure.memberPHRNotFound() =
      MemberPHRNotFound;
}
