// ignore_for_file: inference_failure_on_function_invocation, avoid_dynamic_calls, lines_longer_than_80_chars, inference_failure_on_untyped_parameter

import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/members/model/member_health_info_model.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';

abstract class IMemberService {
  Future<Either<Failure, List<Member>>> getMembers();
  Future<Either<Failure, Member>> addMember(
    bool self,
    String relation,
    String gender,
    String firstName,
    String lastName,
    String dob,
    String email,
    String phoneNumber,
  );
  Future<Either<Failure, Member>> editMember();
  Future<Either<Failure, Member>> memberDetails();
  Future<Either<Failure, MemberHealthInfo>> getMemberHealthInfo();
}

class MemberService implements IMemberService {
  MemberService(this.httpClient);

  final HttpClient httpClient;

  @override
  Future<Either<Failure, List<Member>>> getMembers() async {
    try {
      final response = await httpClient.get('$baseUrl/user/family');

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final data = jsonResponse['data'];
        final members = data.first['users'];
        final parsedMembers = members
            .map<Member>(
              (json) => Member.fromJson(
                Map<String, dynamic>.from(json as Map),
              ),
            )
            .toList();
        return Right(parsedMembers as List<Member>);
      } else {
        return const Left(Failure.badResponse());
      }
    } catch (e) {
      return const Left(Failure.someThingWentWrong());
    }
  }

  @override
  Future<Either<Failure, Member>> addMember(
    bool self,
    String relation,
    String gender,
    String firstName,
    String lastName,
    String dob,
    String email,
    String phoneNumber,
  ) async {
    final newMemberData = {
      'self': self,
      'relation': relation,
      'gender': gender,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'email': email,
      'phoneNumber': phoneNumber,
    };

    try {
      final response = await httpClient.post(
        '$baseUrl/user/add-family',
        data: newMemberData,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final member = Member.fromJson(responseData as Map<String, dynamic>);
        return Right(member);
      }
      if (response.statusCode == 400) {
        final responseData = response.data;
        final errorMessage =
            responseData['error']['message'] ?? 'Validation error occurred';
        final errorDetails =
            responseData['error']['details']['errors'] as List<dynamic>?;
        if (errorDetails != null && errorDetails.isNotEmpty) {
          final field = errorDetails[0]['path'].join(', ');
          final fieldErrorMessage = errorDetails[0]['message'];
          return Left(
            Failure.validationError('$field: $fieldErrorMessage'),
          );
        } else {
          return Left(Failure.validationError('$errorMessage'));
        }
      } else {
        return const Left(Failure.badResponse());
      }
    } catch (e) {
      print(e);
      return const Left(Failure.someThingWentWrong());
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
