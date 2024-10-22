// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_details_model.freezed.dart';
part 'form_details_model.g.dart';

@freezed
class FormDetailModel with _$FormDetailModel {
  const factory FormDetailModel({
    required int id,
    required FormData attributes,
  }) = _FormDetailModel;
  factory FormDetailModel.fromJson(Map<String, dynamic> json) =>
      _$FormDetailModelFromJson(json);
}

@freezed
class FormData with _$FormData {
  const factory FormData({
    required String name,
    required String type,
    required String code,
    required bool isActive,
    required String category,
    required DateTime createdAt,
    required DateTime updatedAt,
    @JsonKey(name: 'product_form') required FormInfoModel productForm,
  }) = _FormData;

  factory FormData.fromJson(Map<String, dynamic> json) =>
      _$FormDataFromJson(json);
}

@freezed
class FormInfoModel with _$FormInfoModel {
  const factory FormInfoModel({
    required Data data,
  }) = _FormInfoModel;
  factory FormInfoModel.fromJson(Map<String, dynamic> json) =>
      _$FormInfoModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    required int id,
    required Attributes attributes,
  }) = _Data;
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Attributes with _$Attributes {
  const factory Attributes({
    required String name,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime publishedAt,
    required List<FormModel> form,
  }) = _Attributes;
  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);
}

@freezed
class FormModel with _$FormModel {
  const factory FormModel({
    required int id,
    @JsonKey(name: '__component') required String component,
    required String type,
    required FormDetails formDetails,
    required dynamic initialValue,
    required dynamic startDate,
    required dynamic endDate,
    @Default(null) String? controlType,
    @Default(0) int defaultValue,
    @Default([]) List<Validations> validations,
    @Default([]) List<Option> options,
    @Default('dd/MM/yyyy') String dateFormat,
  }) = _Form;

  factory FormModel.fromJson(Map<String, dynamic> json) =>
      _$FormModelFromJson(json);
}

@freezed
class FormDetails with _$FormDetails {
  const factory FormDetails({
    required int id,
    required String title,
    required bool required,
    @Default(null) String? requiredMsg,
    required String? placeholder,
    required bool hidden,
    required String? hint,
  }) = _FormDetails;

  factory FormDetails.fromJson(Map<String, dynamic> json) =>
      _$FormDetailsFromJson(json);
}

@freezed
class Option with _$Option {
  const factory Option({
    required int id,
    required String display,
    required String value,
    required bool isDefault,
  }) = _Option;
  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
}

@freezed
class Validations with _$Validations {
  const factory Validations({
    required int id,
    required String type,
    required ValueMsg valueMsg,
  }) = _Validations;

  factory Validations.fromJson(Map<String, dynamic> json) =>
      _$ValidationsFromJson(json);
}

@freezed
class ValueMsg with _$ValueMsg {
  const factory ValueMsg({
    required int id,
    required String value,
    required String message,
  }) = _ValueMsg;
  factory ValueMsg.fromJson(Map<String, dynamic> json) =>
      _$ValueMsgFromJson(json);
}

@freezed
class FormAnswerModel with _$FormAnswerModel {
  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
  )
  const factory FormAnswerModel({
    required List<FormAnswer> formAnswer,
    required int productId,
  }) = _FormAnswerModel;

  factory FormAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$FormAnswerModelFromJson(json);
}

@freezed
class FormAnswer with _$FormAnswer {
  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
  )
  const factory FormAnswer({
    @JsonKey(includeToJson: false) required String forDId,
    required int questionId,
    required String question,
    required String type,
    @Default(null) List<String>? valueChoice,
    String? hint,
    String? controlType,
    @Default(null) List<String>? valueReference,
    String? valueInteger,
    String? valueDate,
    String? valueText,
  }) = _FormAnswer;

  factory FormAnswer.fromJson(Map<String, dynamic> json) =>
      _$FormAnswerFromJson(json);
}
