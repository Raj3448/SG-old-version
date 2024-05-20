// ignore_for_file: inference_failure_on_function_invocation, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/failure/member_services_failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/members/model/epr_models.dart';
import 'package:silver_genie/feature/members/model/member_health_info_model.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';

abstract class IMemberService {
  Future<Either<MemberServiceFailure, List<Member>>> getMembers();
  Future<Either<MemberServiceFailure, Member>> addMember();
  Future<Either<MemberServiceFailure, Member>> editMember();
  Future<Either<MemberServiceFailure, Member>> memberDetails();
  Future<Either<MemberServiceFailure, MemberHealthInfo>> getMemberHealthInfo();
  Future<Either<MemberServiceFailure, EprDataModel>> getEPRData(
      {required String memberId});
}

class MemberServices implements IMemberService {
  MemberServices(this.httpClient);

  final HttpClient httpClient;

  @override
  Future<Either<MemberServiceFailure, List<Member>>> getMembers() async {
    try {
      final response =
          await httpClient.get('https://silvergenie.com/api/v1/members');

      if (response.statusCode == 200) {
        final jsonList = response.data;
        final members = jsonList.map(Member.fromJson).toList();
        return Right(members as List<Member>);
      } else {
        return const Left(MemberServiceFailure.fetchMemberInfoError());
      }
    } catch (e) {
      if (e is SocketException) {
        return const Left(MemberServiceFailure.socketException());
      } else {
        return const Left(MemberServiceFailure.badResponse());
      }
    }
  }

  @override
  Future<Either<MemberServiceFailure, Member>> addMember() async {
    try {
      final response =
          await httpClient.get('https://silvergenie.com/api/v1/members/add');

      if (response.statusCode == 200) {
        final jsonList = response.data;
        return Right(jsonList as Member);
      } else {
        return const Left(MemberServiceFailure.addMemberError());
      }
    } catch (e) {
      if (e is SocketException) {
        return const Left(MemberServiceFailure.socketException());
      } else {
        return const Left(MemberServiceFailure.badResponse());
      }
    }
  }

  @override
  Future<Either<MemberServiceFailure, Member>> editMember() async {
    try {
      final response =
          await httpClient.get('https://silvergenie.com/api/v1/members/edit');

      if (response.statusCode == 200) {
        final jsonList = response.data;
        return Right(jsonList as Member);
      } else {
        return const Left(MemberServiceFailure.memberDetailsEditError());
      }
    } catch (e) {
      if (e is SocketException) {
        return const Left(MemberServiceFailure.socketException());
      } else {
        return const Left(MemberServiceFailure.badResponse());
      }
    }
  }

  @override
  Future<Either<MemberServiceFailure, Member>> memberDetails() async {
    try {
      final response = await httpClient
          .get('https://silvergenie.com/api/v1/members/details');

      if (response.statusCode == 200) {
        final jsonList = response.data;
        return Right(jsonList as Member);
      } else {
        return const Left(MemberServiceFailure.fetchMemberInfoError());
      }
    } catch (e) {
      if (e is SocketException) {
        return const Left(MemberServiceFailure.socketException());
      } else {
        return const Left(MemberServiceFailure.badResponse());
      }
    }
  }

  @override
  Future<Either<MemberServiceFailure, MemberHealthInfo>>
      getMemberHealthInfo() async {
    try {
      final response = await httpClient
          .get('https://silvergenie.com/api/v1/members/healthInfo');

      if (response.statusCode == 200) {
        final jsonList = response.data;
        return Right(jsonList as MemberHealthInfo);
      } else {
        return const Left(MemberServiceFailure.fetchMemberInfoError());
      }
    } catch (e) {
      if (e is SocketException) {
        return const Left(MemberServiceFailure.socketException());
      } else {
        return const Left(MemberServiceFailure.badResponse());
      }
    }
  }

  @override
  Future<Either<MemberServiceFailure, EprDataModel>> getEPRData(
      {required String memberId}) async {
    try {
      final response =
          await httpClient.get('/api/user/family/epr?userId=$memberId');
      if (response.statusCode == 200) {
        final jsonList = response.data;
        if (jsonList['data'] == null && jsonList['details']['name'] == 'EPR_NOT_FOUND') {
          return const Left(MemberServiceFailure.memberDontHaveEPRInfo());
        }
        return Right(
            EprDataModel.fromJson(jsonList['data'] as Map<String, dynamic>));
      } else {
        return const Left(MemberServiceFailure.fetchMemberInfoError());
      }
    } catch (e) {
      if (e is SocketException) {
        return const Left(MemberServiceFailure.socketException());
      } else {
        return const Left(MemberServiceFailure.badResponse());
      }
    }
  }
}
