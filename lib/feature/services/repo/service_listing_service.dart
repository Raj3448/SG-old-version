// ignore_for_file: inference_failure_on_function_invocation

import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/home/model/home_page_model.dart';
import 'package:silver_genie/feature/services/model/service_listing_model.dart';

abstract class IServiceListingService {
  Future<Either<Failure, List<ServiceListingModel>>>
      getAllServicesBasicDetails();
  Future<Either<Failure, ServiceListingModel>> getServiceById();
}

class ServiceListingService extends IServiceListingService {
  HttpClient httpClient;

  ServiceListingService({required this.httpClient});

  @override
  Future<Either<Failure, List<ServiceListingModel>>>
      getAllServicesBasicDetails() async {
    try {
      final response = await httpClient.get(
        '/api/products?populate[0]=subscriptionContent&/populate[1]=icon',
      );

      if (response.statusCode == 200) {
        // print(response);
        // print(response.data);
        final responseList = response.data['data'] as List;
        final serviceList = <ServiceListingModel>[];

        for (final data in responseList) {
          if (data['attributes']['type'] == 'Service') {
            final serviceModel =
                ServiceListingModel.fromJson(data as Map<String, dynamic>);
            serviceList.add(serviceModel);

            // Print the attributes of type 'service'
            print('Service Attributes:');
            print(data['attributes']);
          }
        }

        // final serviceList = response.data;
        return Right(serviceList);
      } else {
        return Left(Failure.badResponse());
      }
    } on SocketException {
      return const Left(Failure.socketException());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }

  Future<Either<Failure, ServiceListingModel>> getServiceById() async {
    try {
      final response = await httpClient.get(
        '/products?populate[0]=subscriptionContent&populate[1]=icon',
      );

      if (response.statusCode == 200) {
        print(response);
        print(response.data);
        final serviceList = response.data;
        return Right(serviceList as ServiceListingModel);
      } else {
        return Left(Failure.badResponse());
      }
    } on SocketException {
      return const Left(Failure.socketException());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }
}
