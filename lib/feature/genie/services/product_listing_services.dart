// ignore_for_file: public_member_api_docs, sort_constructors_first, inference_failure_on_function_invocation, lines_longer_than_80_chars, avoid_dynamic_calls
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/failure/member_services_failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/book_services/model/form_details_model.dart';
import 'package:silver_genie/feature/book_services/model/payment_status_model.dart';
import 'package:silver_genie/feature/book_services/model/service_tracking_response.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';

abstract class IProductListingService {
  Future<Either<Failure, List<ProductBasicDetailsModel>>>
      getAllProductBasicDetails();
  Future<Either<Failure, ProductListingModel>> getProductById({
    required String id,
  });
  Future<Either<Failure, FormDetailModel>> getBookingServiceDetailsById({
    required String productCode,
  });
  Future<Either<MemberServiceFailure, ServiceTrackerResponse>> buyService({
    required FormAnswerModel formData,
  });
  Future<Either<Failure, bool>> bookService({
    required String name,
    required String email,
    required String phoneNumber,
    required String careType,
  });
  Future<Either<Failure, ServicePaymentStatusModel>> getPaymentStatus({
    required String id,
  });
  Future<Either<Failure, SubscriptionDetails>> getSubscriptionPaymentStatus({
    required String id,
  });
  Future<Either<Failure, SubscriptionData>> createSubscription({
    required int priceId,
    required int productId,
    required List<int> familyMemberIds,
  });
}

class ProductListingServices extends IProductListingService {
  HttpClient httpClient;
  ProductListingServices({
    required this.httpClient,
  });

  @override
  Future<Either<Failure, List<ProductBasicDetailsModel>>>
      getAllProductBasicDetails() async {
    late HiveCacheStore cacheStore;
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      cacheStore = HiveCacheStore(
        appDocDir.path,
        hiveBoxName: 'All_product_basic_details',
      );
      final cacheOptions = CacheOptions(
        store: cacheStore,
        policy: CachePolicy.refreshForceCache,
        priority: CachePriority.high,
        maxStale: const Duration(days: 20),
        hitCacheOnErrorExcept: [],
      );

      final dioCacheInterceptor = DioCacheInterceptor(options: cacheOptions);
      httpClient.interceptors.add(dioCacheInterceptor);
      final response = await httpClient.get(
        '/api/products?populate[0]=metadata&populate[1]=icon&populate[2]=upgradeable_products.icon&populate[3]=upgradeable_products.metadata',
      );
      httpClient.interceptors.remove(dioCacheInterceptor);
      switch (response.statusCode) {
        case 200:
          return _processResponseData(response.data);
        case 304:
          return _processResponseData(response.data);
        default:
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
        '/api/products/$id?populate[0]=prices.rules&populate[1]=subscriptionContent.productImage&populate[2]=subscriptionContent.FAQ&populate[3]=icon&populate[4]=benefits&populate[5]=metadata&populate[6]=serviceContent.offerings&populate[7]=serviceContent.serviceImage&populate[8]=serviceContent.faq&populate[9]=serviceContent.servicePrice&populate[10]=serviceContent.cta&populate[11]=serviceContent.bannerImage',
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
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        return const Left(Failure.socketError());
      }
      return const Left(Failure.someThingWentWrong());
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
    required String productCode,
  }) async {
    try {
      final response = await httpClient.get(
        '/api/products?filters[code][\$eq]=$productCode&populate[1]=product_form.form.formDetails&populate[2]=product_form.form.options&populate[3]=product_form.form.validations.valueMsg',
      );
      if (response.statusCode == 200) {
        final data = response.data['data'][0];
        if (data != null) {
          return Right(
            FormDetailModel.fromJson(data as Map<String, dynamic>),
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

  @override
  Future<Either<MemberServiceFailure, ServiceTrackerResponse>> buyService({
    required FormAnswerModel formData,
  }) async {
    try {
      final response = await httpClient.post(
        '/api/service-tracker/request-new',
        data: formData.toJson(),
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null) {
          return Right(
            ServiceTrackerResponse.fromJson(data as Map<String, dynamic>),
          );
        }
        return const Left(MemberServiceFailure.badResponse());
      }
      if(response.statusCode == 404 && response.data['error']['details']['name'] ==
          'SERVICE_NOT_AVAILABLE_FOR_SELECTED_MEMBER'){
          return const Left(MemberServiceFailure.serviceNotAvailbaleForUser());
      }
      else {
        return const Left(MemberServiceFailure.badResponse());
      }
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        return const Left(MemberServiceFailure.socketExceptionError());
      }
      return const Left(MemberServiceFailure.someThingWentWrong());
    } catch (error) {
      return const Left(MemberServiceFailure.someThingWentWrong());
    }
  }

  @override
  Future<Either<Failure, bool>> bookService({
    required String name,
    required String phoneNumber,
    required String email,
    required String careType,
  }) async {
    final data = {
      'data': {
        'fields': {
          'name': name,
          'phone': phoneNumber,
          'email': email,
          'course': 'Silvergenie mobile application',
        },
        'actions': [
          {'type': 'SYSTEM_NOTE', 'text': 'Lead type : Allied care'},
          {
            'type': 'SYSTEM_NOTE',
            'text': 'Allied care type: $careType',
          }
        ],
      },
    };
    final response = await httpClient.post(
      '/api/telecrm/leads',
      data: data,
    );
    if (response.statusCode == 200) {
      return const Right(true);
    } else if (response.statusCode == 403) {
      return Left(Failure.validationError('${response.statusMessage}'));
    }
    return const Left(Failure.badResponse());
  }

  @override
  Future<Either<Failure, SubscriptionData>> createSubscription({
    required int priceId,
    required int productId,
    required List<int> familyMemberIds,
  }) async {
    try {
      final data = {
        'priceId': priceId,
        'productId': productId,
        'familyMemberIds': familyMemberIds,
      };
      final response = await httpClient.post(
        '/api/create-subscription',
        data: data,
      );
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          final data = response.data['data'];
          return Right(
            SubscriptionData.fromJson(data as Map<String, dynamic>),
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

  @override
  Future<Either<Failure, ServicePaymentStatusModel>> getPaymentStatus({
    required String id,
  }) async {
    try {
      final response = await httpClient.get(
        '/api/service-trackers/$id',
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null) {
          return Right(
            ServicePaymentStatusModel.fromJson(data as Map<String, dynamic>),
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

  @override
  Future<Either<Failure, SubscriptionDetails>> getSubscriptionPaymentStatus({
    required String id,
  }) async {
    try {
      final response = await httpClient.get(
        '/api/subscription-trackers/$id',
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null) {
          return Right(
            SubscriptionDetails.fromJson(data as Map<String, dynamic>),
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
