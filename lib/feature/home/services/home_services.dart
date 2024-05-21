import 'package:fpdart/fpdart.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/home/model/home_page_model.dart';
import 'package:silver_genie/feature/home/repository/local/home_page_details.dart';

abstract class IHomeServices {
  Future<Either<Failure, List<dynamic>>> getHomePageInfo();
}

class HomeService implements IHomeServices {
  HomeService(
      {required this.httpClient, required this.homePageComponentDetailscache});

  final HttpClient httpClient;
  final HomePageComponentDetailscache homePageComponentDetailscache;
  @override
  Future<Either<Failure, List<dynamic>>> getHomePageInfo() async {
    try {
      if (homePageComponentDetailscache.isEmpty()) {
        final response = await httpClient.get(
            '/api/pages/1?populate[0]=content.bannerImage&populate[1]=content.cta.href&populate[2]=content.offering.offers.values&populate[3]=content.cta.link&populate[4]=content.testimonials');

        if (response.statusCode == 200) {
          if (response.data['data']['attributes']['content'] != null) {
            List<dynamic> componetList = [];
            for (var component in response.data['data']['attributes']['content']
                as List<dynamic>) {
              if (component['__component'] == 'mobile-ui.banner') {
                componetList.add(BannerImageModel.fromJson(
                    component as Map<String, dynamic>));
              }
              if (component['__component'] == 'mobile-ui.about-us') {
                componetList.add(AboutUsOfferModel.fromJson(
                    component as Map<String, dynamic>));
              }
              if (component['__component'] == 'mobile-ui.testimonials') {
                
                componetList.add(TestimonialsModel.fromJson(
                    component as Map<String, dynamic>));
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
      } else {
        return Right(
              [...?await homePageComponentDetailscache.getComponentDetails()]);
      }
    } catch (er) {
      print(er);
      return const Left(Failure.badResponse());
    }
  }
}
