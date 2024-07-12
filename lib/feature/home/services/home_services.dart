// ignore_for_file: inference_failure_on_function_invocation, avoid_dynamic_calls

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/home/model/home_page_model.dart';
import 'package:silver_genie/feature/home/model/master_data_model.dart';
import 'package:silver_genie/feature/home/repository/local/home_page_details.dart';

abstract class IHomeServices {
  List<dynamic>? getHomePageInfoCache();
  Future<Either<Failure, List<dynamic>>> getHomePageInfo();
  Future<Either<Failure, MasterDataModel>> getMasterData();
}

class HomeService implements IHomeServices {
  HomeService(
      {required this.httpClient,
      required this.homePageComponentDetailscache,
      });

  final HttpClient httpClient;
  final HomePageComponentDetailscache homePageComponentDetailscache;
  @override
  Future<Either<Failure, List<dynamic>>> getHomePageInfo() async {
    try {
      final response = await httpClient.get(
        '/api/pages/1?populate[0]=content.bannerImage&populate[1]=content.cta.href&populate[2]=content.offering.offers.values&populate[3]=content.cta.link&populate[4]=content.testimonials.testifierImage&populate[5]=content.newsletters.link',
      );
      if (response.statusCode == 200) {
        if (response.data['data']['attributes']['content'] != null) {
          final componetList = <dynamic>[];
          final masterData = await getMasterData();
          masterData.fold((l) {
            l.maybeMap(
              socketError: (value) {
                return const Failure.socketError();
              },
              orElse: () {
                return const Failure.someThingWentWrong();
              },
            );
          }, (r) => componetList.add(r));
          for (final component in response.data['data']['attributes']['content']
              as List<dynamic>) {
            if (component['__component'] == 'mobile-ui.banner' &&
                component['isActive'] as bool) {
              componetList.add(
                BannerImageModel.fromJson(component as Map<String, dynamic>),
              );
            }
            if (component['__component'] == 'mobile-ui.about-us') {
              componetList.add(
                AboutUsOfferModel.fromJson(
                  component as Map<String, dynamic>,
                ),
              );
            }
            if (component['__component'] == 'mobile-ui.testimonials') {
              componetList.add(
                TestimonialsModel.fromJson(
                  component as Map<String, dynamic>,
                ),
              );
            }
            if (component['__component'] == 'mobile-ui.news-letter') {
              componetList.add(
                NewsletterModel.fromJson(
                  component as Map<String, dynamic>,
                ),
              );
            }
          }
          await homePageComponentDetailscache
              .storeHomePageComponentDetails(componetList);
          return Right([...componetList]);
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
    } catch (er) {
      return const Left(Failure.badResponse());
    }
  }

  @override
  List<dynamic>? getHomePageInfoCache() {
    return homePageComponentDetailscache.getComponentDetails();
  }

  @override
  Future<Either<Failure, MasterDataModel>> getMasterData() async {
    try {
      final response = await httpClient.get(
        '/api/masterdata?populate=*',
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null) {
          final masterDataModel =
              MasterDataModel.fromJson(data as Map<String, dynamic>);
          return Right(masterDataModel);
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
    } catch (er) {
      return const Left(Failure.badResponse());
    }
  }

  
}
