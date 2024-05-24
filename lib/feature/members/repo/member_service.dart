// ignore_for_file: inference_failure_on_function_invocation, avoid_dynamic_calls, lines_longer_than_80_chars, inference_failure_on_untyped_parameter

import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/failure/member_services_failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/members/model/epr_models.dart';
import 'package:silver_genie/feature/members/model/member_health_info_model.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';

abstract class IMemberService {
  Future<Either<MemberServiceFailure, List<Member>>> getMembers();
  Future<Either<MemberServiceFailure, Member>> addMember(
    bool self,
    String relation,
    String gender,
    String firstName,
    String lastName,
    String dob,
    String email,
    String phoneNumber,
    Address address
  );
  Future<Either<MemberServiceFailure, Member>> updateMember(
    int id,
    Map<String, dynamic> updateData,
  );
  Future<Either<MemberServiceFailure, Member>> memberDetails();
  Future<Either<MemberServiceFailure, MemberHealthInfo>> getMemberHealthInfo();
  Future<Either<MemberServiceFailure, EprDataModel>> getEPRData({
    required String memberId,
  });
}

const baseUrl = '/api';

class MemberServices implements IMemberService {
  MemberServices(this.httpClient);

  final HttpClient httpClient;

  @override
  Future<Either<MemberServiceFailure, List<Member>>> getMembers() async {
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
  Future<Either<MemberServiceFailure, Member>> addMember(
    bool self,
    String relation,
    String gender,
    String firstName,
    String lastName,
    String dob,
    String email,
    String phoneNumber,
    Address address,
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
      'address' : {
        'state': address.state,
        'city': address.city,
        'streetAddress': address.streetAddress,
        'postalCode': address.postalCode,
        'country': address.country
      }
    };

    try {
      final response = await httpClient.post(
        '$baseUrl/user/add-family',
        data: newMemberData,
      );

      if (response.statusCode == 200) {
        final responseData = response.data['data']['users'] as List<dynamic>;
        print(responseData);
        final member = Member.fromJson( responseData.last as Map<String, dynamic>);
        return Right(member);
      }
      if (response.statusCode == 400) {
        final responseData = response.data;
        print(responseData);
        final errorMessage =
            responseData['error']['message'] ?? 'Validation error occurred';
        final errorDetails =
            responseData['error']['details']['errors'] as List<dynamic>?;
        if (errorDetails != null && errorDetails.isNotEmpty) {
          final field = errorDetails[0]['path'].join(', ');
          final fieldErrorMessage = errorDetails[0]['message'];
          return Left(
            MemberServiceFailure.validationError('$field: $fieldErrorMessage'),
          );
        } else {
          return Left(MemberServiceFailure.validationError('$errorMessage'));
        }
      } else {
        return const Left(MemberServiceFailure.addMemberError());
      }
    } catch (e) {
      print(e);
      return const Left(MemberServiceFailure.badResponse());
    }
  }

  @override
  Future<Either<MemberServiceFailure, Member>> updateMember(
    int id,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final response = await httpClient.put(
        '$baseUrl/family/$id/update',
        data: updateData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final member = Member.fromJson(Map<String, dynamic>.from(data as Map));
        // final member = Member.fromJson(responseData as Map<String, dynamic>);
        return Right(member);
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
  Future<Either<MemberServiceFailure, EprDataModel>> getEPRData({
    required String memberId,
  }) async {
    try {
      final response =
          await httpClient.get('/api/user/family/epr?userId=$memberId');
      if (response.statusCode == 200) {
        final jsonList = response.data;
        if (jsonList['data'] == null &&
            jsonList['details']['name'] == 'EPR_NOT_FOUND') {
          return const Left(MemberServiceFailure.memberDontHaveEPRInfo());
        }
        return Right(
          EprDataModel.fromJson(jsonList['data'] as Map<String, dynamic>),
        );
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
