import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'home_page_model.freezed.dart';
part 'home_page_model.g.dart';


@freezed
@HiveType(typeId: 2)
class AboutUsOfferModel with _$AboutUsOfferModel {
  @JsonSerializable(explicitToJson: true)
  const factory AboutUsOfferModel({
    @JsonKey(name: '__component') @HiveField(4) required String component,
    @HiveField(0) required String header,
    @HiveField(1) required String description,
    @HiveField(2) required Cta cta,
    @HiveField(3) required Offering offering,
  }) = _AboutUsOfferModel;

  factory AboutUsOfferModel.fromJson(Map<String, dynamic> json) =>
      _$AboutUsOfferModelFromJson(json);
}


@freezed
@HiveType(typeId: 3)
class BannerImageModel with _$BannerImageModel {
    @JsonSerializable(explicitToJson: true)
    const factory BannerImageModel({
        @JsonKey(name: '__component') @HiveField(4) required String component,
        @HiveField(5) required String label,
        @HiveField(6) required Cta cta,
        @HiveField(7) required BannerImage bannerImage,
    }) = _BannerImageModel;

    factory BannerImageModel.fromJson(Map<String, dynamic> json) => _$BannerImageModelFromJson(json);
}

@freezed
@HiveType(typeId: 4)
class TestimonialsModel with _$TestimonialsModel {
  @JsonSerializable(explicitToJson: true)
  const factory TestimonialsModel({
    @JsonKey(name: '__component') @HiveField(8) required String component,
    @HiveField(9) required String title,
    @HiveField(10) required Testimonials testimonials,
  }) = _TestimonialsModel;

  factory TestimonialsModel.fromJson(Map<String, dynamic> json) => _$TestimonialsModelFromJson(json);
}

@freezed
@HiveType(typeId: 5)
class Testimonials with _$Testimonials {
  @JsonSerializable(explicitToJson: true)
  const factory Testimonials({
    @HiveField(11)required List<Datum> data,
  }) = _Testimonials;

  factory Testimonials.fromJson(Map<String, dynamic> json) => _$TestimonialsFromJson(json);
}

@freezed
@HiveType(typeId: 6)
class Datum with _$Datum {
  @JsonSerializable(explicitToJson: true)
  const factory Datum({
    @HiveField(12) required int id,
    @HiveField(13) required Attributes attributes,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
@HiveType(typeId: 7)
class Attributes with _$Attributes {
  @JsonSerializable(explicitToJson: true)
  const factory Attributes({
    @HiveField(14) required String content,
    @HiveField(15) required String testifierName,
    @HiveField(16) required DateTime createdAt,
    @HiveField(17) required DateTime updatedAt,
    @HiveField(18) required DateTime publishedAt,
  }) = _Attributes;

  factory Attributes.fromJson(Map<String, dynamic> json) => _$AttributesFromJson(json);
}

@freezed
@HiveType(typeId: 8)
class BannerImage with _$BannerImage {
    @JsonSerializable(explicitToJson: true)
    const factory BannerImage({
        @HiveField(19) required Data data,
    }) = _BannerImage;

    factory BannerImage.fromJson(Map<String, dynamic> json) => _$BannerImageFromJson(json);
}

@freezed
@HiveType(typeId: 9)
class Data with _$Data {
    @JsonSerializable(explicitToJson: true)
    const factory Data({
      @JsonKey(name: 'attributes') @HiveField(20) required ImageDataModel attributes,
    }) = _Data;

    factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
@HiveType(typeId: 10)
class ImageDataModel with _$ImageDataModel {
    @JsonSerializable(explicitToJson: true)
    const factory ImageDataModel({
        @Default(double.infinity) @HiveField(21 ) double width,
        @Default(300) @HiveField(22) double height,
        @HiveField(23) required String url,
    }) = _ImageDataModel;

    factory ImageDataModel.fromJson(Map<String, dynamic> json) => _$ImageDataModelFromJson(json);
}
@freezed
@HiveType(typeId: 11)
class Cta with _$Cta {
  @JsonSerializable(explicitToJson: true)
  const factory Cta({
    @HiveField(24) required String label,
    @HiveField(15) String? href,
    @HiveField(26) Link? link,
  }) = _Cta;

  factory Cta.fromJson(Map<String, dynamic> json) => _$CtaFromJson(json);
}

@freezed
@HiveType(typeId: 12)
class Link with _$Link {
  @JsonSerializable(explicitToJson: true)
  const factory Link({
    @HiveField(27) required String href,
    @HiveField(28) String? label,
    @HiveField(29) bool? isExternal,
    @HiveField(30) String? target,
  }) = _Link;

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
}

@freezed
@HiveType(typeId: 13)
class Offering with _$Offering {
  @JsonSerializable(explicitToJson: true)
  const factory Offering({
    @HiveField(31) required String header,
    @Default([]) @HiveField(32) List<Offer> offers,
  }) = _Offering;

  factory Offering.fromJson(Map<String, dynamic> json) =>
      _$OfferingFromJson(json);
}

@freezed
@HiveType(typeId: 14)
class Offer with _$Offer {
  @JsonSerializable(explicitToJson: true)
  const factory Offer({
    @HiveField(33) required String title,
    @Default([]) @HiveField(34) List<Value> values,
  }) = _Offer;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}

@freezed
@HiveType(typeId: 15)
class Value with _$Value {
  @JsonSerializable(explicitToJson: true)
  const factory Value({
    @HiveField(35) required String value,
  }) = _Value;

  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);
}