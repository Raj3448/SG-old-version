// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
part 'service_banner_image.g.dart';
part 'service_banner_image.freezed.dart';

@freezed
class ServiceBannerImage with _$ServiceBannerImage {
  const factory ServiceBannerImage({
    required int id,
    @JsonKey(name: '__component') required String component,
    required String label,
    required bool isActive,
    required BannerImage bannerImage,
    required Cta? cta,
  }) = _ServiceBannerImage;
  factory ServiceBannerImage.fromJson(Map<String, dynamic> json) =>
      _$ServiceBannerImageFromJson(json);
}

@freezed
class BannerImage with _$BannerImage {
  const factory BannerImage({
    required List<Datum> data,
  }) = _BannerImage;
  factory BannerImage.fromJson(Map<String, dynamic> json) =>
      _$BannerImageFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    required int id,
    required Attributes attributes,
  }) = _Datum;
  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class Attributes with _$Attributes {
  const factory Attributes({
    required String name,
    required dynamic width,
    required dynamic height,
    required String url,
  }) = _Attributes;
  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);
}

@freezed
class Cta with _$Cta {
  const factory Cta({
    required int id,
    required String href,
    required String? label,
    required bool isExternal,
    required String target,
    required bool downloadLink,
  }) = _Cta;
  factory Cta.fromJson(Map<String, dynamic> json) => _$CtaFromJson(json);
}
