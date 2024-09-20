// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/custom_extension.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/bookings/model/booking_service_model.dart';

abstract class IBookingService {
  Future<Either<Failure, BookingServices>> getBookingServiceBasicDetails();
}

class BookingService extends IBookingService {
  HttpClient httpClient;
  BookingService({
    required this.httpClient,
  });

  @override
  Future<Either<Failure, BookingServices>>
      getBookingServiceBasicDetails() async {
    // ignore: strict_raw_type
    late final Response response;
    try {
      // ignore: inference_failure_on_function_invocation
      response = await httpClient.get(
        '/api/service-tracker/me',
      );
      if (response.statusCode == 200) {
        if (response.data != null) {
          final data = response.data;
          return Right(
            BookingServices.fromJson(data as Map<String, dynamic>),
          );
        }
        return const Left(Failure.badResponse())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      } else {
        return const Left(Failure.badResponse())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      }
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        return const Left(Failure.socketError())
          ..firebaseCrashAnalyticsLogApiFailure(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              apiUrl: response.realUri.toString());
      }
      return const Left(Failure.someThingWentWrong())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: 'Dio Exception',
            apiUrl: response.realUri.toString());
    } catch (error) {
      return const Left(Failure.someThingWentWrong())
        ..firebaseCrashAnalyticsLogApiFailure(
            statusCode: response.statusCode,
            statusMessage: error.toString(),
            apiUrl: response.realUri.toString());
    }
  }
}
