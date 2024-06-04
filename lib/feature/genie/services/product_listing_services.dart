// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_dynamic_calls, inference_failure_on_function_invocation
import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';

abstract class IProductListingService {
  Future<Either<Failure, List<ProductBasicDetailsModel>>>
      getAllProductBasicDetails();
  Future<Either<Failure, ProductListingModel>> getProductById({
    required String id,
  });
}

class ProductLisitingServices extends IProductListingService {
  HttpClient httpClient;
  ProductLisitingServices({
    required this.httpClient,
  });

  @override
  Future<Either<Failure, List<ProductBasicDetailsModel>>>
      getAllProductBasicDetails() async {
    try {
      final response = await httpClient.get(
        '/api/products?populate[0]=metadata&populate[1]=icon&populate[2]=upgradeable_products.icon&populate[3]=upgradeable_products.metadata',
      );
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          final receivedList = response.data['data'] as List;
          final allProductList = <ProductBasicDetailsModel>[];
          for (final data in receivedList) {
            allProductList.add(
              ProductBasicDetailsModel.fromJson(
                data as Map<String, dynamic>,
              ),
            );
          }
          return Right([...allProductList]);
        }
        return const Left(Failure.badResponse());
      } else {
        return const Left(Failure.badResponse());
      }
    } on SocketException {
      return const Left(Failure.socketException());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }

  @override
  Future<Either<Failure, ProductListingModel>> getProductById({
    required String id,
  }) async {
    try {
      final response = await httpClient.get(
        '/api/products/$id?populate[0]=prices.rules&populate[1]=subscriptionContent.productImage&populate[2]=subscriptionContent.FAQ&populate[3]=icon&populate[4]=benefits&populate[5]=metadata&populate[6]=serviceContent',
      );
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          return Right(
            ProductListingModel.fromJson(
              response.data['data'] as Map<String, dynamic>,
            ),
          );
        }
        return const Left(Failure.badResponse());
      } else {
        return const Left(Failure.badResponse());
      }
    } on SocketException {
      return const Left(Failure.socketException());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }

  List<Price> getPlansforNonCouple(List<Price> prices) {
    return prices
        .where((element) => element.benefitApplicableToMembersLimit != 2)
        .toList();
  }

  List<Price> getPlansforCouple(List<Price> prices) {
    return prices
        .where((element) => element.benefitApplicableToMembersLimit == 2)
        .toList();
  }
}
