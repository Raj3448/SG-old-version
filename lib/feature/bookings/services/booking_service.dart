// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/dummy_variables.dart';
import 'package:silver_genie/feature/bookings/model/booking_service_model.dart';

abstract class IBookingService {
  Future<Either<Failure, List<BookingServiceModel>>>
      getBookingServiceBasicDetails();
}

class BookingService extends IBookingService {
  HttpClient httpClient;
  BookingService({
    required this.httpClient,
  });

  @override
  Future<Either<Failure, List<BookingServiceModel>>>
      getBookingServiceBasicDetails() async {
    try {
      return Right(bookingServicesList);
    } catch (e) {
      return const Left(Failure.someThingWentWrong());
    }
  }
}
