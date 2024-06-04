import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_listing_model.freezed.dart';
part 'service_listing_model.g.dart';

@freezed
class ServiceListingModel with _$ServiceListingModel {
  factory ServiceListingModel({
    required int id,
    required Attributes attributes,
  }) = _ServiceListingModel;

  factory ServiceListingModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceListingModelFromJson(json);
}

@freezed
class Attributes with _$Attributes {
  factory Attributes({
    required String name,
    required String type,
    required String code,
    required bool isActive,
    required String category,
    required DateTime createdAt,
    required DateTime updatedAt,
    required SubscriptionContent subscriptionContent,
    required IconData icon,
  }) = _Attributes;

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);
}

@freezed
class SubscriptionContent with _$SubscriptionContent {
  factory SubscriptionContent({
    required int id,
    required String mainHeading,
    required String headingDescription,
    required String subHeading1,
    required String subHeading1Description,
    required bool showSinglesPlan,
    required bool showCouplePlans,
    required String faqHeading,
    required String exploreNowCTALabel,
    required String benefitsHeading,
    String? exploreCouplePlansHeading,
  }) = _SubscriptionContent;

  factory SubscriptionContent.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionContentFromJson(json);
}

@freezed
class IconData with _$IconData {
  factory IconData({
    required int id,
    required IconAttributes attributes,
  }) = _IconData;

  factory IconData.fromJson(Map<String, dynamic> json) =>
      _$IconDataFromJson(json);
}

@freezed
class IconAttributes with _$IconAttributes {
  factory IconAttributes({
    required String name,
    required int width,
    required int height,
    required Formats formats,
    required String hash,
    required String ext,
    required String mime,
    required double size,
    required String url,
    required String provider,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? alternativeText,
    String? caption,
    String? previewUrl,
    String? providerMetadata,
  }) = _IconAttributes;

  factory IconAttributes.fromJson(Map<String, dynamic> json) =>
      _$IconAttributesFromJson(json);
}

@freezed
class Formats with _$Formats {
  factory Formats({
    required Thumbnail thumbnail,
  }) = _Formats;

  factory Formats.fromJson(Map<String, dynamic> json) =>
      _$FormatsFromJson(json);
}

@freezed
class Thumbnail with _$Thumbnail {
  factory Thumbnail({
    required String ext,
    required String url,
    required String hash,
    required String mime,
    required String name,
    required double size,
    required int width,
    required int height,
    required int sizeInBytes,
    String? path,
  }) = _Thumbnail;

  factory Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);
}
