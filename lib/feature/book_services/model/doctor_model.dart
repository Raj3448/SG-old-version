import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor_model.freezed.dart';
part 'doctor_model.g.dart';

@freezed
class DoctorModel with _$DoctorModel {
  const factory DoctorModel({
    required String imgPath,
    required String name,
    required String yoe,
    required String type,
    required String info,
    required String hospital,
    required String charges,
    required List<String> expertise,
    required List<String> preferredLang,
  }) = _DoctorModel;

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);
}
