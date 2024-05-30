import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_listing_model.freezed.dart';
part 'product_listing_model.g.dart';

@freezed
class ProductListingModel with _$ProductListingModel {
  const factory ProductListingModel({
    required int id,
    @JsonKey(name: 'attributes') required Product product,
  }) = _ProductListingModel;

  factory ProductListingModel.fromJson(Map<String, dynamic> json) =>
      _$ProductListingModelFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    required String name,
    required String type,
    required String code,
    required bool isActive,
    required String category,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<Metadatum> metadata,
    required List<Price> prices,
    required SubscriptionContent subscriptionContent,
    required List<dynamic> serviceContent,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

@freezed
class Metadatum with _$Metadatum {
  const factory Metadatum({
    required int id,
    required String key,
    required String value,
  }) = _Metadatum;

  factory Metadatum.fromJson(Map<String, dynamic> json) => _$MetadatumFromJson(json);
}

@freezed
class Price with _$Price {
  const factory Price({
    required int id,
    required int unitAmount,
    required String label,
    required String billingScheme,
    required String pricingType,
    required String recurringInterval,
    required int recurringIntervalCount,
    required String code,
    required dynamic recurringPlanId,
    required int benefitApplicableToMembersLimit,
    required int? discountPercentage,
    required int? amountWithoutDiscount,
  }) = _Price;

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
}

@freezed
class SubscriptionContent with _$SubscriptionContent {
  const factory SubscriptionContent({
    required int id,
    required String mainHeading,
    required String headingDescription,
    required String subHeading1,
    required String subHeading1Description,
    required bool showSinglesPlan,
    required bool showCouplePlans,
    required String exploreCouplePlansHeading,
    required String faqHeading,
    @JsonKey(name: 'exploreNowCTALabel') required String exploreNowCtaLabel,
    required String benefitsHeading,
  }) = _SubscriptionContent;

  factory SubscriptionContent.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionContentFromJson(json);
}