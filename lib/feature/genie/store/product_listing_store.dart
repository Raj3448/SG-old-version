import 'package:mobx/mobx.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';
import 'package:silver_genie/feature/genie/services/product_listing_services.dart';
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
  bool isProductLoaded = false;

  @observable
  bool? hasGotProductSuccesfully;

  @computed
  List<ProductBasicDetailsModel> get getSubscriptActiveProdList =>
      productBasicDetailsModelList != null
          ? productBasicDetailsModelList!
              .where(
                (element) =>
                    element.attributes.isActive &&
                    element.attributes.type == 'subscription',
              )
              .toList()
          : [];

  @computed
  List<ProductBasicDetailsModel> get getSubscriptProdList =>
      productBasicDetailsModelList != null
          ? productBasicDetailsModelList!
              .where((element) => element.attributes.type == 'subscription')
              .toList()
          : [];

  @computed
  List<ProductBasicDetailsModel> get getServicesList =>
      productBasicDetailsModelList != null
          ? productBasicDetailsModelList!
              .where((element) => element.attributes.type == 'service')
              .toList()
          : [];

  @computed
  List<ProductBasicDetailsModel> get getConvenienceCareServicesList =>
      productBasicDetailsModelList != null
          ? productBasicDetailsModelList!
              .where(
                (element) =>
                    element.attributes.category == 'convenienceCare' &&
                    element.attributes.isActive == true &&
                    element.attributes.type == 'service',
              )
              .toList()
          : [];

  @computed
  List<ProductBasicDetailsModel> get getHomeCareServicesList =>
      productBasicDetailsModelList != null
          ? productBasicDetailsModelList!
              .where(
                (element) =>
                    element.attributes.category == 'homeCare' &&
                    element.attributes.isActive == true &&
                    element.attributes.type == 'service',
              )
              .toList()
          : [];

  @computed
  List<ProductBasicDetailsModel> get getHealthCareServicesList =>
      productBasicDetailsModelList != null
          ? productBasicDetailsModelList!
              .where(
                (element) =>
                    element.attributes.category == 'healthCare' &&
                    element.attributes.isActive == true &&
                    element.attributes.type == 'service',
              )
              .toList()
          : [];

  @action
  List<ProductBasicDetailsModel> getUpgradeProdListById(String id) {
    return getSubscriptProdList
        .where((element) => element.id.toString() == id)
        .map((element) => element.attributes.upgradableProducts.data)
        .expand((element) => element)
        .toList();
  }

  void initGetProductBasicDetails() {
    fetchProductLoading = true;
    productListingService.getAllProductBasicDetails().then((value) {
      value.fold((l) {
        l.maybeMap(
          socketException: (value) => getProductFailure = 'No Internet',
          orElse: () {
            getProductFailure = 'Something went wrong';
          },
        );
      }, (r) {
        productBasicDetailsModelList = r;
        isProductLoaded = true;
      });
      fetchProductLoading = false;
    });
  }
}
