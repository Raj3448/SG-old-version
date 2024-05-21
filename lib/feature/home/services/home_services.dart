import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/home/model/home_page_model.dart';

abstract class IHomeServices {
  Future<Either<Failure, HomePageModel>> getHomePageInfo();
}

class HomeService implements IHomeServices {
  HomeService({required this.httpClient});

  final HttpClient httpClient;
  @override
  Future<Either<Failure, HomePageModel>> getHomePageInfo() async {
    try {
      final response = await httpClient.get(
          '/api/pages/1?populate[0]=content.bannerImage&populate[1]=content.cta.href&populate[2]=content.offering.offers.values&populate[3]=content.cta.link&populate[4]=content.testimonials');
      if (response.statusCode == 200) {
        if (response.data['data']['attributes']['content'] != null) {
          AboutUsOfferModel? aboutUsOfferModel;
          BannerImageModel? bannerImageModel;
          for (var component in response.data['data']['attributes']['content']
              as List<dynamic>) {
            if (component['__component'] == 'mobile-ui.banner') {

              bannerImageModel = BannerImageModel.fromJson(component as Map<String,dynamic>);
            }
            if (component['__component'] == 'mobile-ui.about-us') {
              aboutUsOfferModel = AboutUsOfferModel.fromJson(component as Map<String,dynamic>);
            }
          }
          return Right(HomePageModel(aboutUsOfferModel: aboutUsOfferModel!, bannerImageModel: bannerImageModel!));
        } else {
          return const Left(Failure.badResponse());
        }
      } else {
        return const Left(Failure.badResponse());
      }
    } catch (er) {
      print(er);
      return const Left(Failure.badResponse());
    }
  }
}