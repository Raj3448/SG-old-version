// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';

abstract class IProductListingService {
  Future<Either<Failure, List<ProductListingModel>>> getAllProducts();
  Future<Either<Failure, List<ProductBasicDetailsModel>>> getAllProductBasicDetails();
}

class ProductLisitingServices extends IProductListingService {
  HttpClient httpClient;
  ProductLisitingServices({
    required this.httpClient,
  });
  @override
  Future<Either<Failure, List<ProductListingModel>>> getAllProducts() async {
    try {
      final response = await httpClient.get('/api/products?populate=*');
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          final receivedList = response.data['data'] as List;
          var allProductList = <ProductListingModel>[];
          for (var data in receivedList) {
            allProductList.add(
                ProductListingModel.fromJson(data as Map<String, dynamic>));
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
  Future<Either<Failure, List<ProductBasicDetailsModel>>> getAllProductBasicDetails() async{
    try {
      final response = await httpClient.get('/api/products');
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          final receivedList = response.data['data'] as List;
          var allProductList = <ProductBasicDetailsModel>[];
          for (var data in receivedList) {
            allProductList.add(
                ProductBasicDetailsModel.fromJson(data as Map<String, dynamic>));
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
}
