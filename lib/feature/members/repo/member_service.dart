// ignore_for_file: inference_failure_on_function_invocation, avoid_dynamic_calls, lines_longer_than_80_chars, inference_failure_on_untyped_parameter

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/member_services_failure.dart';
import 'package:silver_genie/core/utils/custom_extension.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/members/model/epr_models.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';

abstract class IMemberService {
  Future<Either<MemberServiceFailure, List<Member>>> getMembers();
  Future<Either<MemberServiceFailure, Member>> addMember(
    Map<String, dynamic> memberData,
    String? imgId,
  );
  Future<Either<MemberServiceFailure, Member>> addMemberDataWithProfileImg({
    required File fileImage,
    required Map<String, dynamic> memberInfo,
  });
  Future<Either<MemberServiceFailure, bool>> updateMember(
    String id,
    Map<String, dynamic> updateData,
    String? imgId,
  );
  Future<Either<MemberServiceFailure, bool>> updateMemberDataWithProfileImg({
    required String id,
    required File fileImage,
    required Map<String, dynamic> memberInfo,
  });
  Future<Either<MemberServiceFailure, EprDataModel>> getEPRData({
    required String memberId,
  });
  Future<Either<MemberServiceFailure, String>> getPHRPdfPath({
    required String memberPhrId,
  });
}

class MemberServices implements IMemberService {
  MemberServices(this.httpClient);

  final HttpClient httpClient;

  @override
  Future<Either<MemberServiceFailure, List<Member>>> getMembers() async {
    // ignore: strict_raw_type
    late final Response response;
    try {
      response = await httpClient.get('/api/user/family');

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
      } else if (response.statusCode == 400) {
        return const Left(MemberServiceFailure.badResponse())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else if (response.statusCode == 500) {
        return const Left(MemberServiceFailure.internalServerError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else if (response.statusCode == 502) {
        return const Left(MemberServiceFailure.badGatewayError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else {
        return const Left(MemberServiceFailure.fetchMemberInfoError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      }
    } on SocketException {
      return const Left(MemberServiceFailure.socketExceptionError())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            apiUrl: response.realUri.toString());
    } catch (e) {
      return const Left(MemberServiceFailure.badResponse())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            apiUrl: response.realUri.toString());
    }
  }

  @override
  Future<Either<MemberServiceFailure, Member>> addMember(
    Map<String, dynamic> memberData,
    String? imgId,
  ) async {
    // ignore: strict_raw_type
    late final Response response;
    try {
      if (imgId != null) {
        memberData['profileImg'] = imgId;
      }
      response = await httpClient.post(
        '/api/user/add-family',
        data: memberData,
      );

      if (response.statusCode == 200) {
        final responseData = response.data['data']['users'] as List<dynamic>;
        final member =
            Member.fromJson(responseData.last as Map<String, dynamic>);
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
            MemberServiceFailure.validationError('$field: $fieldErrorMessage'),
          )..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
        } else {
          return Left(MemberServiceFailure.validationError('$errorMessage'))
            ..firebaseCrashAnalyticsLogApiFailure(
                statusCode: response.statusCode,
                statusMessage: response.statusMessage,
                apiUrl: response.realUri.toString());
        }
      } else if (response.statusCode == 500) {
        return const Left(MemberServiceFailure.internalServerError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else if (response.statusCode == 502) {
        return const Left(MemberServiceFailure.badGatewayError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else {
        return const Left(MemberServiceFailure.addMemberError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      }
    } on SocketException {
      return const Left(MemberServiceFailure.socketExceptionError())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            apiUrl: response.realUri.toString());
    } catch (e) {
      return const Left(MemberServiceFailure.badResponse())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            apiUrl: response.realUri.toString());
    }
  }

  @override
  Future<Either<MemberServiceFailure, Member>> addMemberDataWithProfileImg({
    required File fileImage,
    required Map<String, dynamic> memberInfo,
  }) async {
    // ignore: strict_raw_type
    late final Response response;
    try {
      final formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(
          fileImage.path,
        ),
      });
      response = await httpClient.post(
        '/api/upload',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      if (response.statusCode == 200) {
        final imageId = response.data[0]['id'];
        if (imageId != null) {
          return await addMember(
            memberInfo,
            imageId.toString(),
          );
        } else {
          return const Left(MemberServiceFailure.badResponse())
            ..firebaseCrashAnalyticsLogApiFailure(
                statusCode: response.statusCode,
                statusMessage: response.statusMessage,
                apiUrl: response.realUri.toString());
        }
      } else if (response.statusCode == 400) {
        return const Left(MemberServiceFailure.badResponse())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else if (response.statusCode == 500) {
        return const Left(MemberServiceFailure.internalServerError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else if (response.statusCode == 502) {
        return const Left(MemberServiceFailure.badGatewayError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else {
        return const Left(MemberServiceFailure.badResponse())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      }
    } on SocketException {
      return const Left(MemberServiceFailure.socketExceptionError())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            apiUrl: response.realUri.toString());
    } catch (error) {
      return const Left(MemberServiceFailure.badResponse())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            apiUrl: response.realUri.toString());
    }
  }

  @override
  Future<Either<MemberServiceFailure, bool>> updateMember(
    String id,
    Map<String, dynamic> updateData,
    String? imgId,
  ) async {
    // ignore: strict_raw_type
    late final Response response;
    try {
      if (imgId != null) {
        updateData['profileImg'] = imgId;
      }

      response = await httpClient.put(
        '/api/family/$id/update',
        data: updateData,
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else if (response.statusCode == 400) {
        return const Left(MemberServiceFailure.badResponse())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else if (response.statusCode == 500) {
        return const Left(MemberServiceFailure.internalServerError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else if (response.statusCode == 502) {
        return const Left(MemberServiceFailure.badGatewayError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else {
        return const Left(MemberServiceFailure.memberDetailsEditError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      }
    } on SocketException {
      return const Left(MemberServiceFailure.socketExceptionError())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            apiUrl: response.realUri.toString());
    } catch (e) {
      if (e is SocketException) {
        return const Left(MemberServiceFailure.socketExceptionError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else {
        return const Left(MemberServiceFailure.badResponse())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      }
    }
  }

  @override
  Future<Either<MemberServiceFailure, bool>> updateMemberDataWithProfileImg({
    required String id,
    required File fileImage,
    required Map<String, dynamic> memberInfo,
  }) async {
    // ignore: strict_raw_type
    late final Response response;
    try {
      final formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(
          fileImage.path,
        ),
      });
      response = await httpClient.post(
        '/api/upload',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      if (response.statusCode == 200) {
        final imageId = response.data[0]['id'];
        if (imageId != null) {
          return await updateMember(
            id,
            memberInfo,
            imageId.toString(),
          );
        } else {
          return const Left(MemberServiceFailure.badResponse());
        }
      }
      if (response.statusCode == 413 &&
          response.statusMessage == 'Request Entity Too Large') {
        return const Left(MemberServiceFailure.uploadImageEntityTooLarge())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      }
      if (response.statusCode == 400) {
        return const Left(MemberServiceFailure.badResponse())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      }
      if (response.statusCode == 500) {
        return const Left(MemberServiceFailure.internalServerError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      }
      if (response.statusCode == 502) {
        return const Left(MemberServiceFailure.badGatewayError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else {
        return const Left(MemberServiceFailure.badResponse())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      }
    } on SocketException {
      return const Left(MemberServiceFailure.socketExceptionError())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            apiUrl: response.realUri.toString());
    } catch (error) {
      return const Left(MemberServiceFailure.badResponse())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            apiUrl: response.realUri.toString());
    }
  }

  @override
  Future<Either<MemberServiceFailure, EprDataModel>> getEPRData({
    required String memberId,
  }) async {
    // ignore: strict_raw_type
    late final Response response;
    try {
      response = await httpClient.get('/api/user/family/epr?userId=$memberId');
      if (response.statusCode == 200) {
        final jsonList = response.data;
        if (jsonList['data'] == null &&
            jsonList['details']['name'] == 'EPR_NOT_FOUND') {
          return const Left(MemberServiceFailure.memberDontHaveEPRInfo())
            ..firebaseCrashAnalyticsLogApiFailure(
                statusCode: response.statusCode,
                statusMessage: response.statusMessage,
                apiUrl: response.realUri.toString());
        }
        return Right(
          EprDataModel.fromJson(jsonList['data'] as Map<String, dynamic>),
        );
      } else if (response.statusCode == 400) {
        return const Left(MemberServiceFailure.badResponse())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else if (response.statusCode == 500) {
        return const Left(MemberServiceFailure.internalServerError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else if (response.statusCode == 502) {
        return const Left(MemberServiceFailure.badGatewayError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else {
        return const Left(MemberServiceFailure.fetchMemberInfoError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      }
    } on SocketException {
      return const Left(MemberServiceFailure.socketExceptionError())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            apiUrl: response.realUri.toString());
    } catch (e) {
      return const Left(MemberServiceFailure.badResponse())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            apiUrl: response.realUri.toString());
    }
  }

  @override
  Future<Either<MemberServiceFailure, String>> getPHRPdfPath({
    required String memberPhrId,
  }) async {
    // ignore: strict_raw_type
    late final Response response;
    try {
      response = await httpClient.get('/api/phr/pdf/$memberPhrId/generate');
      if (response.statusCode == 200) {
        if (response.data['details'] != null &&
            response.data['details']['name'] == 'NO_PHR_FOUND') {
          return const Left(MemberServiceFailure.memberPHRNotFound())
            ..firebaseCrashAnalyticsLogApiFailure(
                statusCode: response.statusCode,
                statusMessage: response.statusMessage,
                apiUrl: response.realUri.toString());
        }
        if (response.data['pdfPath'] != null) {
          return Right(response.data['pdfPath'] as String);
        }
        return const Left(MemberServiceFailure.badResponse())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else if (response.statusCode == 400) {
        return const Left(MemberServiceFailure.badResponse())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else if (response.statusCode == 500) {
        return const Left(MemberServiceFailure.internalServerError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else if (response.statusCode == 502) {
        return const Left(MemberServiceFailure.badGatewayError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else {
        return const Left(MemberServiceFailure.badResponse())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      }
    } on SocketException {
      return const Left(MemberServiceFailure.socketExceptionError())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            apiUrl: response.realUri.toString());
    } catch (error) {
      return const Left(MemberServiceFailure.badResponse())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            apiUrl: response.realUri.toString());
    }
  }
}
