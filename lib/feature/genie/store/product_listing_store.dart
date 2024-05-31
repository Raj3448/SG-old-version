import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/services/product_listing_services.dart';
import 'package:collection/collection.dart';
part 'product_listing_store.g.dart';

class ProductListingStore = _ProductListingStoreBase with _$ProductListingStore;

abstract class _ProductListingStoreBase with Store {
  _ProductListingStoreBase({required this.productListingService});

  final IProductListingService productListingService;

  @observable
  bool fetchProductLoading = false;

  @observable
  List<ProductBasicDetailsModel>? productBasicDetailsModelList;

  @observable
  String? getProductFailure;

  @observable
  bool? hasGotProductSuccesfully;

  void initGetProductBasicDetails() {
    fetchProductLoading = true;
    productListingService.getAllProductBasicDetails().then((value) {
      value.fold((l) {
        l.maybeMap(
            socketException: (value) => getProductFailure = 'No Internet',
            orElse: () {
              getProductFailure = 'Something went wrong';
              print('I am failure to fetch product');
            });
      }, (r) {
        productBasicDetailsModelList = r;
      });
      fetchProductLoading = false;
    });
  }

  // void getAllProducts() {
  //   isLoading = true;
  //   if (productListingModelList == null) {
  //     // ignore: unawaited_futures
  //     productListingService.getAllProducts().then((value) =>

  //       value.fold((l) {
  //         l.maybeMap(socketException: (value) {
  //           getProductFailure = 'No Internet';
  //         }, orElse: () {
  //           getProductFailure = 'Something went wrong';
  //         });
  //         hasGotProductSuccesfully = false;
  //       }, (r) {
  //         productListingModelList = r;
  //         hasGotProductSuccesfully = true;
  //       })
  //     );
  //       isLoading = false;
  //   } else {
  //     isLoading = false;
  //   }
  // }
}
