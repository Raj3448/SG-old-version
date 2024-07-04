import 'package:fpdart/fpdart.dart';
import 'package:mobx/mobx.dart';
import 'package:silver_genie/core/failure/failure.dart';
import 'package:silver_genie/core/payment/payment_services.dart';
import 'package:silver_genie/feature/book_services/model/form_details_model.dart';
import 'package:silver_genie/feature/book_services/model/service_tracking_response.dart';
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

  @observable
  bool isBuyServiceLoading = false;

  @observable
  String? buyServiceFailed;

  @observable
  ServiceTrackerResponse? servicePaymentInfoGotSuccess;

  @observable
  PaymentStatus? paymentStatus;

  @observable
  bool isLoading = false;

  @observable
  Price? _planDetails;

  @observable
  ProductListingModel? subscriptionModel;

  @observable
  bool subscriptionLoading = false;

  @computed
  Price? get planDetails => _planDetails;

  @action
  void updatePlan(Price? plan) {
    _planDetails = plan;
  }

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

  List<ProductBasicDetailsModel> getProdListRankOrder(
    List<ProductBasicDetailsModel> prodList,
  ) {
    return prodList
        .where(
          (element) => element.attributes.metadata
              .any((metadata) => metadata.key == 'rank'),
        )
        .toList()
      ..sort((a, b) {
        final aRank = a.attributes.metadata
            .firstWhere((metadata) => metadata.key == 'rank')
            .value;
        final bRank = b.attributes.metadata
            .firstWhere((metadata) => metadata.key == 'rank')
            .value;
        return aRank.compareTo(bRank);
      });
  }

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
          socketError: (value) => getProductFailure = 'No Internet',
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

  void buyService({required FormAnswerModel formData}) {
    isBuyServiceLoading = true;
    productListingService.buyService(formData: formData).then((value) {
      value.fold((l) {
        l.maybeMap(
          socketError: (value) => buyServiceFailed = 'No Internet Connection',
          orElse: () => buyServiceFailed = 'Something went wrong',
        );
      }, (r) {
        servicePaymentInfoGotSuccess = r;
      });
      isBuyServiceLoading = false;
    });
  }

  Future<Either<Failure, SubscriptionData>> createSubscription({
    required int priceId,
    required int productId,
    required List<int> familyMemberIds,
  }) async {
    isLoading = true;
    final response = await productListingService.createSubscription(
      priceId: priceId,
      productId: productId,
      familyMemberIds: familyMemberIds,
    );
    isLoading = false;
    return response;
  }

  @action
  Future<void> getProductById({
    required String id,
  }) async {
    subscriptionLoading = true;
    final response = await productListingService.getProductById(id: id);
    subscriptionLoading = false;
    response.fold(
      (failure) {
        subscriptionModel = null;
      },
      (productListingModel) {
        subscriptionModel = productListingModel;
      },
    );
  }
}
