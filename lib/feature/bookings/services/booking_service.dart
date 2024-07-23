// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
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
    try {
      // ignore: inference_failure_on_function_invocation
      final response = await httpClient.get(
        '/api/service-tracker/me',
      );
      if (response.statusCode == 200) {
        if (response.data != null) {
          final data = response.data;
          return Right(
            BookingServices.fromJson(data as Map<String, dynamic>),
          );
        }
        return const Left(Failure.badResponse());
      } else {
        return const Left(Failure.badResponse());
      }
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        return const Left(Failure.socketError());
      }
      return const Left(Failure.someThingWentWrong());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }
}
