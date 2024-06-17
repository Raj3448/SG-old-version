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
    required List<FormModel> form,
  }) = _FormData;

  factory FormData.fromJson(Map<String, dynamic> json) =>
      _$FormDataFromJson(json);
}

@freezed
class FormModel with _$FormModel {
  const factory FormModel({
    required int id,
    @JsonKey(name: '__component') required String component,
    @Default(null) String? controlType,
    required String type,
    required FormDetails formDetails,
    required dynamic initialValue,
    @Default(0) int defaultValue,
    @Default([]) List<Validations> validations,
    @Default([]) List<Option> options,
    required dynamic startDate,
    required dynamic endDate,
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
    required String requiredMsg,
    required String? placeholder,
    required bool hidden,
    required String? hint,
    required String code,
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
  @JsonSerializable(includeIfNull: false,explicitToJson: true,)
  const factory FormAnswerModel({
    required List<FormAnswer> formAnswer,
    required int productId,
  }) = _FormAnswerModel;

  factory FormAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$FormAnswerModelFromJson(json);
}

@freezed
class FormAnswer with _$FormAnswer {
  @JsonSerializable(includeIfNull: false,explicitToJson: true)
  const factory FormAnswer({
    @JsonKey(includeToJson: false) required String forDId,
    required int id,
    required String questionTitle,
    required String type,
    String? valueChoice,
    String? hint,
    String? controlType,
    List<String>? valueReference,
  }) = _FormAnswer;

  factory FormAnswer.fromJson(Map<String, dynamic> json) =>
      _$FormAnswerFromJson(json);
}
