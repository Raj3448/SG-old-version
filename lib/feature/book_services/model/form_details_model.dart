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
    required List<Form> form,
  }) = _FormData;

  factory FormData.fromJson(Map<String, dynamic> json) =>
      _$FormDataFromJson(json);
}

@freezed
class Form with _$Form {
  const factory Form({
    required int id,
    @JsonKey(name: '__component') required String component,
    @Default(null) String? controlType,
    required String type,
    required FormDetails formDetails,
    required dynamic initialValue,
    @Default([]) List<dynamic> validations,
    @Default([]) List<Option> options,
    required dynamic startDate,
    required dynamic endDate,
    @Default('dd/MM/yyyy') String dateFormat,
  }) = _Form;

  factory Form.fromJson(Map<String, dynamic> json) =>
      _$FormFromJson(json);
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
  factory Option.fromJson(Map<String, dynamic> json) =>
      _$OptionFromJson(json);
}
