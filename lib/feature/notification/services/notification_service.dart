// ignore_for_file: public_member_api_docs, sort_constructors_first, inference_failure_on_function_invocation
// ignore_for_file: lines_longer_than_80_chars, one_member_abstracts
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/custom_extension.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/notification/model/notification_model.dart';

abstract class INotificationFacade {
  Future<Either<Failure, NotificationModel>> fetchNotification();
  Future<Either<Failure, bool>> storeFcmTokenIntoServer({
    required String? fcmToken,
  });
  Future<Either<Failure, bool>> markToReadById({
    required String notificationId,
  });
}

class NotificationServices extends INotificationFacade {
  NotificationServices({required this.httpClient});

  final HttpClient httpClient;
  @override
  Future<Either<Failure, NotificationModel>> fetchNotification() async {
    // ignore: strict_raw_type
    late final Response response;
    try {
      response = await httpClient.get('/api/user-notifications');

      if (response.statusCode == 200) {
        if (response.data != null) {
          return Right(
            NotificationModel.fromJson(
              response.data! as Map<String, dynamic>,
            ),
          );
        }
        return const Left(Failure.badResponse())..firebaseCrashAnalyticsLogApiFailure(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          apiUrl: response.realUri.toString()
        );
      } else {
        return const Left(Failure.badResponse())..firebaseCrashAnalyticsLogApiFailure(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          apiUrl: response.realUri.toString()
        );
      }
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        return const Left(Failure.socketError())..firebaseCrashAnalyticsLogApiFailure(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          apiUrl: response.realUri.toString()
        );
      }
      return const Left(Failure.someThingWentWrong())..firebaseCrashAnalyticsLogApiFailure(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          apiUrl: response.realUri.toString()
        );
    } catch (error) {
      return const Left(Failure.someThingWentWrong())..firebaseCrashAnalyticsLogApiFailure(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          apiUrl: response.realUri.toString()
        );
    }
  }

  @override
  Future<Either<Failure, bool>> storeFcmTokenIntoServer({
    required String? fcmToken,
  }) async {
    // ignore: strict_raw_type
    late final Response response;
    try {
      response = await httpClient.post(
        '/api/auth/local/fcm',
        data: {'token': fcmToken},
      );
      if (response.statusCode == 200) {
        return const Right(
          true,
        );
      } else {
        return const Left(Failure.badResponse());
      }
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        return const Left(Failure.socketError())..firebaseCrashAnalyticsLogApiFailure(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          apiUrl: response.realUri.toString()
        );
      }
      return const Left(Failure.someThingWentWrong())..firebaseCrashAnalyticsLogApiFailure(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          apiUrl: response.realUri.toString()
        );
    } catch (error) {
      return const Left(Failure.someThingWentWrong())..firebaseCrashAnalyticsLogApiFailure(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          apiUrl: response.realUri.toString()
        );
    }
  }

  @override
  Future<Either<Failure, bool>> markToReadById({
    required String notificationId,
  }) async {
    // ignore: strict_raw_type
    late final Response response;
    try {
      response = await httpClient.post(
        '/api/user-notifications/$notificationId/mark-as-read',
      );
      if (response.statusCode == 200) {
        return const Right(
          true,
        );
      } else {
        return const Left(Failure.badResponse())..firebaseCrashAnalyticsLogApiFailure(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          apiUrl: response.realUri.toString()
        );
      }
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        return const Left(Failure.socketError())..firebaseCrashAnalyticsLogApiFailure(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          apiUrl: response.realUri.toString()
        );
      }
      return const Left(Failure.someThingWentWrong())..firebaseCrashAnalyticsLogApiFailure(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          apiUrl: response.realUri.toString()
        );
    } catch (error) {
      return const Left(Failure.someThingWentWrong())..firebaseCrashAnalyticsLogApiFailure(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          apiUrl: response.realUri.toString()
        );
    }
  }
}
