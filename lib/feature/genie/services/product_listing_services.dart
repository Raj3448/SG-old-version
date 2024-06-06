// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';

abstract class IProductListingService {
  Future<Either<Failure, List<ProductBasicDetailsModel>>>
      getAllProductBasicDetails();
  Future<Either<Failure, ProductListingModel>> getProductById(
      {required String id});
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
      final appDocDir = await getApplicationDocumentsDirectory();
      final cacheStore = HiveCacheStore(
        appDocDir.path,
        hiveBoxName: 'All_product_basic_details',
      );
      final cacheOptions = CacheOptions(
        store: cacheStore,
        policy: CachePolicy.refresh,
        priority: CachePriority.high,
        maxStale: const Duration(minutes: 50),
        hitCacheOnErrorExcept: [401, 404],
      );
      final dioCacheInterceptor = DioCacheInterceptor(options: cacheOptions);
      httpClient.interceptors.add(dioCacheInterceptor);
      final response = await httpClient.get(
        '/api/products?populate[0]=metadata&populate[1]=icon&populate[2]=upgradeable_products.icon&populate[3]=upgradeable_products.metadata',
        options: Options(
          extra: {'cacheOptions': cacheOptions},
        ),
      );
      httpClient.interceptors.remove(dioCacheInterceptor);
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          final receivedList = response.data['data'] as List;
          var allProductList = <ProductBasicDetailsModel>[];
          for (var data in receivedList) {
            allProductList.add(ProductBasicDetailsModel.fromJson(
                data as Map<String, dynamic>));
          }
          return Right([...allProductList]);
        }
        return const Left(Failure.badResponse());
      } else if (response.statusCode == 304) {
        final cachedResponse = await httpClient.get(
          '/api/products?populate[0]=metadata&populate[1]=icon&populate[2]=upgradeable_products.icon&populate[3]=upgradeable_products.metadata',
          options: Options(
            extra: {
              'cacheOptions': cacheOptions.copyWith(policy: CachePolicy.noCache)
            },
          ),
        );
        if (cachedResponse.data['data'] != null) {
          final receivedList = cachedResponse.data['data'] as List;
          var allProductList = <ProductBasicDetailsModel>[];
          for (var data in receivedList) {
            allProductList.add(ProductBasicDetailsModel.fromJson(
                data as Map<String, dynamic>));
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
  Future<Either<Failure, ProductListingModel>> getProductById(
      {required String id}) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final cacheStore = HiveCacheStore(
        appDocDir.path,
        hiveBoxName: 'getProductById:$id',
      );
      final cacheOptions = CacheOptions(
        store: cacheStore,
        policy: CachePolicy.refresh,
        priority: CachePriority.high,
        maxStale: const Duration(minutes: 50),
        hitCacheOnErrorExcept: [401, 404],
      );
      final dioCacheInterceptor = DioCacheInterceptor(options: cacheOptions);
      httpClient.interceptors.add(dioCacheInterceptor);
      final response = await httpClient.get(
          '/api/products/$id?populate[0]=prices.rules&populate[1]=subscriptionContent.productImage&populate[2]=subscriptionContent.FAQ&populate[3]=icon&populate[4]=benefits&populate[5]=metadata&populate[6]=serviceContent');
      httpClient.interceptors.remove(dioCacheInterceptor);
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          return Right(ProductListingModel.fromJson(
              response.data['data'] as Map<String, dynamic>));
        }
        return const Left(Failure.badResponse());
      }
      else if (response.statusCode == 304) {
        print("Im here#######################");
        final cachedResponse = await httpClient.get(
          '/api/products/$id?populate[0]=prices.rules&populate[1]=subscriptionContent.productImage&populate[2]=subscriptionContent.FAQ&populate[3]=icon&populate[4]=benefits&populate[5]=metadata&populate[6]=serviceContent',
          options: Options(
            extra: {
              'cacheOptions': cacheOptions.copyWith(policy: CachePolicy.noCache)
            },
          ),
        );
        if (cachedResponse.data['data'] != null) {
          return Right(ProductListingModel.fromJson(
              response.data['data'] as Map<String, dynamic>));
        }
        return const Left(Failure.badResponse());
      }
      else {
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
