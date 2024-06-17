// ignore_for_file: public_member_api_docs, sort_constructors_first, inference_failure_on_function_invocation
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/book_services/model/form_details_model.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';

abstract class IProductListingService {
  Future<Either<Failure, List<ProductBasicDetailsModel>>>
      getAllProductBasicDetails();
  Future<Either<Failure, ProductListingModel>> getProductById({
    required String id,
  });
  Future<Either<Failure, FormDetailModel>> getBookingServiceDetailsById({
    required String id,
  });
  Future<Either<Failure, String>> buyService({
    required FormAnswerModel formData,
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
      final appDocDir = await getApplicationDocumentsDirectory();
      final cacheStore = HiveCacheStore(
        appDocDir.path,
        hiveBoxName: 'All_product_basic_details',
      );
      final cacheOptions = CacheOptions(
        store: cacheStore,
        policy: CachePolicy.request,
        priority: CachePriority.high,
        maxStale: const Duration(days: 100),
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
      switch (response.statusCode) {
        case 200:
          print('Need to fetch');
          return _processResponseData(response.data);
        default:
          return const Left(Failure.badResponse());
      }
    } on SocketException {
      return const Left(Failure.socketException());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }

  Either<Failure, List<ProductBasicDetailsModel>> _processResponseData(
    dynamic data,
  ) {
    if (data['data'] != null) {
      final receivedList = data['data'] as List;
      var allProductList = <ProductBasicDetailsModel>[];
      for (var item in receivedList) {
        allProductList.add(
          ProductBasicDetailsModel.fromJson(item as Map<String, dynamic>),
        );
      }
      return Right([...allProductList]);
    }
    return const Left(Failure.badResponse());
  }

  @override
  Future<Either<Failure, ProductListingModel>> getProductById({
    required String id,
  }) async {
    try {
      final response = await httpClient.get(
        '/api/products/$id?populate[0]=prices.rules&populate[1]=subscriptionContent.productImage&populate[2]=subscriptionContent.FAQ&populate[3]=icon&populate[4]=benefits&populate[5]=metadata&populate[6]=serviceContent.offerings&populate[7]=serviceContent.serviceImage&populate[8]=serviceContent.faq',
      );
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          final data = response.data['data'];
          return Right(
            ProductListingModel.fromJson(data as Map<String, dynamic>),
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

  @override
  Future<Either<Failure, FormDetailModel>> getBookingServiceDetailsById({
    required String id,
  }) async {
    try {
      final response = await httpClient.get(
        '/api/products/$id?populate[form][populate][0]=formDetails&populate[form][populate][1]=validations.valueMsg&populate[form][populate][2]=options',
      );
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          final data = response.data['data'];
          return Right(
            FormDetailModel.fromJson(data as Map<String, dynamic>),
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

  @override
  Future<Either<Failure, String>> buyService(
      {required FormAnswerModel formData}) async {
    try {
      return const Right('Response received successfully');
    }on SocketException {
      return const Left(Failure.socketException());
    } catch (error) {
      return const Left(Failure.someThingWentWrong());
    }
  }
}
