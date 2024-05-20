import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_model.freezed.dart';
part 'home_page_model.g.dart';

@freezed
class HomePageModel with _$HomePageModel{
  @JsonSerializable(explicitToJson: true)
  const factory HomePageModel({
    required AboutUsOfferModel aboutUsOfferModel,
    required BannerImageModel bannerImageModel,
  }) = _HomePageModel;

  factory HomePageModel.fromJson(Map<String, dynamic> json) =>
      _$HomePageModelFromJson(json);
}

@freezed
class AboutUsOfferModel with _$AboutUsOfferModel {
  @JsonSerializable(explicitToJson: true)
  const factory AboutUsOfferModel({
    @JsonKey(name: '__component') required String component,
    required String header,
    required String description,
    required Cta cta,
    required Offering offering,
  }) = _AboutUsOfferModel;

  factory AboutUsOfferModel.fromJson(Map<String, dynamic> json) =>
      _$AboutUsOfferModelFromJson(json);
}


@freezed
class BannerImageModel with _$BannerImageModel {
    @JsonSerializable(explicitToJson: true)
    const factory BannerImageModel({
        required String label,
        required Cta cta,
        required BannerImage bannerImage,
    }) = _BannerImageModel;

    factory BannerImageModel.fromJson(Map<String, dynamic> json) => _$BannerImageModelFromJson(json);
}

@freezed
class BannerImage with _$BannerImage {
    @JsonSerializable(explicitToJson: true)
    const factory BannerImage({
        required Data data,
    }) = _BannerImage;

    factory BannerImage.fromJson(Map<String, dynamic> json) => _$BannerImageFromJson(json);
}

@freezed
class Data with _$Data {
    @JsonSerializable(explicitToJson: true)
    const factory Data({
      @JsonKey(name: 'attributes') required ImageDataModel attributes,
    }) = _Data;

    factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class ImageDataModel with _$ImageDataModel {
    @JsonSerializable(explicitToJson: true)
    const factory ImageDataModel({
        @Default(double.infinity) double width,
        @Default(300) double height,
        required String url,
    }) = _ImageDataModel;

    factory ImageDataModel.fromJson(Map<String, dynamic> json) => _$ImageDataModelFromJson(json);
}
@freezed
class Cta with _$Cta {
  @JsonSerializable(explicitToJson: true)
  const factory Cta({
    required String label,
    String? href,
    Link? link,
  }) = _Cta;

  factory Cta.fromJson(Map<String, dynamic> json) => _$CtaFromJson(json);
}

@freezed
class Link with _$Link {
  @JsonSerializable(explicitToJson: true)
  const factory Link({
    required String href,
    String? label,
    bool? isExternal,
    String? target,
  }) = _Link;

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
}

@freezed
class Offering with _$Offering {
  @JsonSerializable(explicitToJson: true)
  const factory Offering({
    required String header,
    @Default([]) List<Offer> offers,
  }) = _Offering;

  factory Offering.fromJson(Map<String, dynamic> json) =>
      _$OfferingFromJson(json);
}

@freezed
class Offer with _$Offer {
  @JsonSerializable(explicitToJson: true)
  const factory Offer({
    required String title,
    @Default([]) List<Value> values,
  }) = _Offer;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}

@freezed
class Value with _$Value {
  @JsonSerializable(explicitToJson: true)
  const factory Value({
    required String value,
  }) = _Value;

  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);
}