// ignore_for_file: inference_failure_on_function_invocation, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/members/model/member_health_info_model.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';

abstract class MemberService {
  Future<Either<Failure, List<Member>>> getMembers();
  Future<Either<Failure, Member>> addMember();
  Future<Either<Failure, Member>> editMember();
  Future<Either<Failure, Member>> memberDetails();
  Future<Either<Failure, MemberHealthInfo>> getMemberHealthInfo();
}

class FetchMemberData implements MemberService {
  FetchMemberData(this.httpClient);

  final HttpClient httpClient;

  @override
  Future<Either<Failure, List<Member>>> getMembers() async {
    try {
      final response =
          await httpClient.get('https://silvergenie.com/api/v1/members');

      if (response.statusCode == 200) {
        final jsonList = response.data;
        final members = jsonList.map(Member.fromJson).toList();
        return Right(members as List<Member>);
      } else {
        return const Left(Failure.badResponse());
      }
    } catch (e) {
      if (e is SocketException) {
        return const Left(Failure.socketException());
      } else {
        return const Left(Failure.someThingWentWrong());
      }
    }
  }

  @override
  Future<Either<Failure, Member>> addMember() async {
    try {
      final response =
          await httpClient.get('https://silvergenie.com/api/v1/members/add');

      if (response.statusCode == 200) {
        final jsonList = response.data;
        return Right(jsonList as Member);
      } else {
        return const Left(Failure.badResponse());
      }
    } catch (e) {
      if (e is SocketException) {
        return const Left(Failure.socketException());
      } else {
        return const Left(Failure.someThingWentWrong());
      }
    }
  }

  @override
  Future<Either<Failure, Member>> editMember() async {
    try {
      final response =
          await httpClient.get('https://silvergenie.com/api/v1/members/edit');

      if (response.statusCode == 200) {
        final jsonList = response.data;
        return Right(jsonList as Member);
      } else {
        return const Left(Failure.badResponse());
      }
    } catch (e) {
      if (e is SocketException) {
        return const Left(Failure.socketException());
      } else {
        return const Left(Failure.someThingWentWrong());
      }
    }
  }

  @override
  Future<Either<Failure, Member>> memberDetails() async {
    try {
      final response = await httpClient
          .get('https://silvergenie.com/api/v1/members/details');

      if (response.statusCode == 200) {
        final jsonList = response.data;
        return Right(jsonList as Member);
      } else {
        return const Left(Failure.badResponse());
      }
    } catch (e) {
      if (e is SocketException) {
        return const Left(Failure.socketException());
      } else {
        return const Left(Failure.someThingWentWrong());
      }
    }
  }

  @override
  Future<Either<Failure, MemberHealthInfo>> getMemberHealthInfo() async {
    try {
      final response = await httpClient
          .get('https://silvergenie.com/api/v1/members/healthInfo');

      if (response.statusCode == 200) {
        final jsonList = response.data;
        return Right(jsonList as MemberHealthInfo);
      } else {
        return const Left(Failure.badResponse());
      }
    } catch (e) {
      if (e is SocketException) {
        return const Left(Failure.socketException());
      } else {
        return const Left(Failure.someThingWentWrong());
      }
    }
  }

  
}
