import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silver_genie/feature/user_profile/model/user_details.dart';

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
    required List<Price> prices,
    required SubscriptionContent? subscriptionContent,
    @JsonKey(name: 'icon') required IconImage icon,
    required Benefits benefits,
    required List<Metadatum> metadata,
    @Default([]) List<dynamic>? serviceContent,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
class Benefits with _$Benefits {
  const factory Benefits({
    required List<Datum> data,
  }) = _Benefits;

  factory Benefits.fromJson(Map<String, dynamic> json) =>
      _$BenefitsFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    required int id,
    required DatumAttributes attributes,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class DatumAttributes with _$DatumAttributes {
  const factory DatumAttributes({
    required String label,
    required String code,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DatumAttributes;

  factory DatumAttributes.fromJson(Map<String, dynamic> json) =>
      _$DatumAttributesFromJson(json);
}

@freezed
class Metadatum with _$Metadatum {
  const factory Metadatum({
    required int id,
    required String key,
    required String value,
  }) = _Metadatum;

  factory Metadatum.fromJson(Map<String, dynamic> json) =>
      _$MetadatumFromJson(json);
}

@freezed
class Price with _$Price {
  const factory Price({
    required int id,
    required int unitAmount,
    required String label,
    required String? billingScheme,
    required String pricingType,
    required String? recurringInterval,
    required int? recurringIntervalCount,
    required String code,
    required dynamic recurringPlanId,
    required int benefitApplicableToMembersLimit,
    required int? discountPercentage,
    required int? amountWithoutDiscount,
    required List<Rule> rules,
    @Default(false) bool isSelected,
  }) = _Price;

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
}

@freezed
class Rule with _$Rule {
  const factory Rule({
    required int id,
    required String ruleType,
    required String value,
    required String label,
  }) = _Rule;

  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);
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
    required String? exploreCouplePlansHeading,
    required String faqHeading,
    @JsonKey(name: 'exploreNowCTALabel') required String exploreNowCtaLabel,
    required String benefitsHeading,
    @JsonKey(name: 'FAQ') required List<Faq> faq,
    required ProductImage productImage,
  }) = _SubscriptionContent;

  factory SubscriptionContent.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionContentFromJson(json);
}

@freezed
class Faq with _$Faq {
  const factory Faq({
    required int id,
    required String question,
    required String answer,
  }) = _Faq;
  factory Faq.fromJson(Map<String, dynamic> json) => _$FaqFromJson(json);
}

@freezed
class ProductImage with _$ProductImage {
  const factory ProductImage({
    @JsonKey(name: 'data') required ImgDetail data,
  }) = _ProductImage;

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);
}

@freezed
class ImgDetail with _$ImgDetail {
  const factory ImgDetail({
    required int id,
    required DataAttributes attributes,
  }) = _ImgDetail;

  factory ImgDetail.fromJson(Map<String, dynamic> json) =>
      _$ImgDetailFromJson(json);
}

@freezed
class DataAttributes with _$DataAttributes {
  const factory DataAttributes({
    required String name,
    required int width,
    required int height,
    required Formats formats,
    required String hash,
    required String url,
    required dynamic previewUrl,
  }) = _DataAttributes;

  factory DataAttributes.fromJson(Map<String, dynamic> json) =>
      _$DataAttributesFromJson(json);
}

///==============================================================================

@freezed
class ProductBasicDetailsModel with _$ProductBasicDetailsModel {
  const factory ProductBasicDetailsModel({
    required int id,
    @JsonKey(name: 'attributes') required ProductMetaData attributes,
  }) = _ProductBasicDetailsModel;

  factory ProductBasicDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductBasicDetailsModelFromJson(json);
}

@freezed
class ProductMetaData with _$ProductMetaData {
  const factory ProductMetaData({
    required String name,
    required String type,
    required String code,
    required bool isActive,
    required String category,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<Metadatum> metadata,
    @JsonKey(name: 'icon') required IconImage icon,
    @JsonKey(name: 'upgradeable_products')
    @Default(UpgradableProducts(data: []))
    UpgradableProducts upgradableProducts,
  }) = _ProductMetaData;

  factory ProductMetaData.fromJson(Map<String, dynamic> json) =>
      _$ProductMetaDataFromJson(json);
}

@freezed
class IconImage with _$IconImage {
  const factory IconImage({
    required Data data,
  }) = _IconImage;
  factory IconImage.fromJson(Map<String, dynamic> json) =>
      _$IconImageFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    required int id,
    @JsonKey(name: 'attributes') required IconImgMetaData attributes,
  }) = _Data;
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class IconImgMetaData with _$IconImgMetaData {
  const factory IconImgMetaData({
    required String name,
    required dynamic alternativeText,
    required dynamic caption,
    required int width,
    required int height,
    required dynamic formats,
    required String hash,
    required String ext,
    required String mime,
    required double size,
    required String url,
    required dynamic previewUrl,
    required String provider,
    required dynamic providerMetadata,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _IconImgMetaData;

  factory IconImgMetaData.fromJson(Map<String, dynamic> json) =>
      _$IconImgMetaDataFromJson(json);
}

@freezed
class UpgradableProducts with _$UpgradableProducts {
  const factory UpgradableProducts({
    required List<ProductBasicDetailsModel> data,
  }) = _UpgradableProducts;

  factory UpgradableProducts.fromJson(Map<String, dynamic> json) =>
      _$UpgradableProductsFromJson(json);
}
