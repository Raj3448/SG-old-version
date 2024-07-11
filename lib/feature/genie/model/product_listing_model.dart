// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silver_genie/feature/home/model/home_page_model.dart';
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
    required int? id,
    required String name,
    required String type,
    required String? code,
    required bool? isActive,
    required String category,
    required DateTime? createdAt,
    required DateTime? updatedAt,
    required List<Price> prices,
    required SubscriptionContent? subscriptionContent,
    @JsonKey(name: 'icon') required IconImage? icon,
    required Benefits? benefits,
    required List<Metadatum>? metadata,
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
    required dynamic recurringPlanId,
    required int benefitApplicableToMembersLimit,
    required int? discountPercentage,
    required int? amountWithoutDiscount,
    @Default([]) List<Rule>? rules,
    @Default(false) bool? isSelected,
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
    @JsonKey(name: 'FAQ') @Default([]) List<Faq>? faq,
    @Default(null) ProductImage? productImage,
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
    @JsonKey(name: 'provider_metadata') required dynamic providerMetadata,
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

@freezed
class HeaderModel with _$HeaderModel {
  const factory HeaderModel({
    required int id,
    @JsonKey(name: '__component') required String component,
    required String heading,
    required String description,
    required String headingAlignment,
    required BannerImage serviceImage,
  }) = _HeaderModel;
  factory HeaderModel.fromJson(Map<String, dynamic> json) =>
      _$HeaderModelFromJson(json);
}

@freezed
class ServiceOfferingModel with _$ServiceOfferingModel {
  const factory ServiceOfferingModel({
    required int id,
    @JsonKey(name: '__component') required String component,
    required String label,
    required List<OfferingList> offerings,
  }) = _ServiceOfferingModel;
  factory ServiceOfferingModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceOfferingModelFromJson(json);
}

@freezed
class ServicePriceModel with _$ServicePriceModel {
  const factory ServicePriceModel({
    required int id,
    @JsonKey(name: '__component') required String component,
    required String label,
    required int startPrice,
    @Default(null) String? priceSuperscript,
    @Default(null) String? priceDescription,
    @Default(null) int? endPrice,
  }) = _ServicePriceModel;

  factory ServicePriceModel.fromJson(Map<String, dynamic> json) =>
      _$ServicePriceModelFromJson(json);
}

@freezed
class OfferingList with _$OfferingList {
  const factory OfferingList({
    required int id,
    required String value,
  }) = _OfferingList;
  factory OfferingList.fromJson(Map<String, dynamic> json) =>
      _$OfferingListFromJson(json);
}

@freezed
class FaqModelDetails with _$FaqModelDetails {
  const factory FaqModelDetails({
    required int id,
    @JsonKey(name: '__component') required String component,
    required String label,
    required List<Faq> faq,
  }) = _FaqModelDetails;
  factory FaqModelDetails.fromJson(Map<String, dynamic> json) =>
      _$FaqModelDetailsFromJson(json);
}

@freezed
class BookSubscriptionModel with _$BookSubscriptionModel {
  const factory BookSubscriptionModel({
    required SubscriptionData data,
    required Details details,
    required bool success,
  }) = _BookSubscriptionModel;

  factory BookSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$BookSubscriptionModelFromJson(json);
}

@freezed
class SubscriptionData with _$SubscriptionData {
  const factory SubscriptionData({
    required int id,
    required String paymentStatus,
    required String status,
    required DateTime expiresOn,
    required DateTime startDate,
    required int priceId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required SubscriptionProduct product,
    required int userId,
    required List<int> familyMemberIds,
    required int amount,
    required String razorpaySubscriptionId,
    @JsonKey(name: 'razorpay_api_key') required String razorpayApiKey,
    @JsonKey(name: 'Subscription') required Subscription? subscription,
  }) = _SubscriptionData;

  factory SubscriptionData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDataFromJson(json);
}

@freezed
class SubscriptionProduct with _$SubscriptionProduct {
  const factory SubscriptionProduct({
    required int id,
    required String category,
    required String name,
    required String type,
    required List<Price> prices,
  }) = _SubscriptionProduct;

  factory SubscriptionProduct.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionProductFromJson(json);
}

@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String entity,
    @JsonKey(name: 'plan_id') required String planId,
    required String status,
    @JsonKey(name: 'current_start') required dynamic currentStart,
    @JsonKey(name: 'current_end') required dynamic currentEnd,
    @JsonKey(name: 'ended_at') required dynamic endedAt,
    required int quantity,
    required Notes? notes,
    @JsonKey(name: 'charge_at') required dynamic chargeAt,
    @JsonKey(name: 'start_at') required dynamic startAt,
    @JsonKey(name: 'end_at') required dynamic endAt,
    @JsonKey(name: 'auth_attempts') required int authAttempts,
    @JsonKey(name: 'total_count') required int totalCount,
    @JsonKey(name: 'paid_count') required int paidCount,
    @JsonKey(name: 'customer_notify') required bool customerNotify,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'expire_by') required dynamic expireBy,
    @JsonKey(name: 'short_url') required String shortUrl,
    @JsonKey(name: 'has_scheduled_changes') required bool hasScheduledChanges,
    @JsonKey(name: 'change_scheduled_at') required dynamic changeScheduledAt,
    required String source,
    @JsonKey(name: 'remaining_count') required int remainingCount,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}

@freezed
class SubscriptionTracker with _$SubscriptionTracker {
  const factory SubscriptionTracker({
    required int id,
    required String paymentStatus,
    required String status,
    required DateTime expiresOn,
    required DateTime startDate,
    required int amount,
    required int priceId,
    required dynamic razorpaySubscriptionId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SubscriptionTracker;

  factory SubscriptionTracker.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionTrackerFromJson(json);
}

@freezed
class Notes with _$Notes {
  const factory Notes({
    required String subscriptionTrackerId,
  }) = _Notes;

  factory Notes.fromJson(Map<String, dynamic> json) => _$NotesFromJson(json);
}

@freezed
class Details with _$Details {
  const factory Details({
    required String message,
    required String name,
    required int status,
  }) = _Details;

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);
}

@freezed
class SubscriptionModel with _$SubscriptionModel {
  const factory SubscriptionModel({
    required List<SubscriptionDetails> data,
  }) = _SubscriptionModel;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);
}

@freezed
class SubscriptionDetails with _$SubscriptionDetails {
  const factory SubscriptionDetails({
    required int id,
    required String paymentStatus,
    required String status,
    required DateTime expiresOn,
    required DateTime startDate,
    required int amount,
    required int priceId,
    required String? razorpaySubscriptionId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String? subscriptionStatus,
    required List<dynamic>? metadata,
    required Product product,
    required FamilyMember? subscribedBy,
    required List<FamilyMember>? belongsTo,
    @Default([]) List<dynamic>? payment_transactions,
    @Default([]) List<DatumAttributes>? benefits,
    required RazorpaySubscription razorpay_subscription,
  }) = _SubscriptionDetails;

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDetailsFromJson(json);
}

@freezed
class FamilyMember with _$FamilyMember {
  const factory FamilyMember({
    required int id,
    required String firstName,
    required String lastName,
    required String gender,
    required String relation,
    required String dateOfBirth,
    required IconImgMetaData? profileImg,
  }) = _FamilyMember;

  factory FamilyMember.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberFromJson(json);
}

@freezed
class RazorpaySubscription with _$RazorpaySubscription {
  const factory RazorpaySubscription({
    required int id,
    required String subscriptionId,
    required String status,
    required String planId,
    required DateTime? chargeAt,
    required int totalCount,
    required int paidCount,
    required dynamic shortUrl,
    required bool hasScheduledChanges,
    required int remainingCount,
    required dynamic customerId,
    required DateTime currentStart,
    required DateTime currentEnd,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RazorpaySubscription;

  factory RazorpaySubscription.fromJson(Map<String, dynamic> json) =>
      _$RazorpaySubscriptionFromJson(json);
}
