import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/failure/member_services_failure.dart';
import 'package:silver_genie/feature/user_profile/store/user_details_store.dart';

extension CapitalizeFirstWord on String {
  String capitalizeFirstWord() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

extension FirebaseCrashAnalytics1<T> on Left<Failure, T> {
  void firebaseCrashAnalyticsLogApiFailure({
    required int? statusCode,
    required String? statusMessage,
    required String? apiUrl,
  }) {
    fold(
      (failure) => _logApiFailure(
        failure: failure,
        statusCode: statusCode,
        statusMessage: statusMessage,
        apiUrl: apiUrl,
      ),
      (success) {},
    );
  }
}

extension FirebaseCrashAnalytics2<T> on Left<MemberServiceFailure, T> {
  void firebaseCrashAnalyticsLogApiFailure({
    required int? statusCode,
    required String? statusMessage,
    required String? apiUrl,
  }) {
    fold(
      (failure) => _logApiMemberFailure(
        failure: failure,
        statusCode: statusCode,
        statusMessage: statusMessage,
        apiUrl: apiUrl,
      ),
      (success) {},
    );
  }
}

void _logApiMemberFailure({
  required MemberServiceFailure failure,
  required int? statusCode,
  required String? statusMessage,
  required String? apiUrl,
}) {
  final currentUser = GetIt.I<UserDetailStore>().userDetails;

  failure.maybeMap(socketExceptionError: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API call failed: No internet connection'),
      null,
      reason:
          'API Failure: No internet connection | StatusCode: N/A | Message: No internet connection | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, badResponse: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Bad response | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, memberDontHaveEPRInfo: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          "API Failure: Member don't have EPR Info | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}",
    );
  }, addMemberError: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Add member error | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, badGatewayError: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Bad gateway error | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, eprDataFetchError: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: EPR data fetching | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, fetchMemberInfoError: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Fetching member info | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, internalServerError: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Internal server error | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, memberDetailsEditError: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Member details editing | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, memberPHRNotFound: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Member PHR not found | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, serviceNotAvailbaleForUser: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Service not available for selected user | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, uploadImageEntityTooLarge: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Image entity too large | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, validationError: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Validation error | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, someThingWentWrong: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Something went wrong | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, orElse: () {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $failure'),
      null,
      reason:
          'API Failure: Unknown error | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  });
  FirebaseCrashlytics.instance.sendUnsentReports();
}

void _logApiFailure({
  required Failure failure,
  required int? statusCode,
  required String? statusMessage,
  required String? apiUrl,
}) {
  final currentUser = GetIt.I<UserDetailStore>().userDetails;

  failure.maybeMap(socketError: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API call failed: No internet connection'),
      null,
      reason:
          'API Failure: No internet connection | StatusCode: N/A | Message: No internet connection | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, badResponse: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Bad response | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, hiveError: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Hive Error | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, entityTooLargeError: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Image entity too large | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, someThingWentWrong: (value) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $statusCode, $statusMessage'),
      null,
      reason:
          'API Failure: Something went wrong | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  }, orElse: () {
    FirebaseCrashlytics.instance.recordError(
      Exception('API failed: $failure'),
      null,
      reason:
          'API Failure: Unknown error | StatusCode: $statusCode | Message: $statusMessage | API_Url: $apiUrl | UserId: ${currentUser?.id} | UserEmail: ${currentUser?.email}',
    );
  });
  FirebaseCrashlytics.instance
      .setUserIdentifier(currentUser?.id.toString() ?? '');
  FirebaseCrashlytics.instance.sendUnsentReports();
}
