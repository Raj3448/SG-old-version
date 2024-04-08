class DoctorModel {
  DoctorModel({
    required this.name,
    required this.yoe,
    required this.type,
    required this.info,
    required this.hospital,
    required this.charges,
    required this.expertise,
    required this.preferredLang,
    required this.imgPath,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      imgPath: json['imgPath'] as String,
      name: json['name'] as String,
      yoe: json['yoe'] as String,
      type: json['type'] as String,
      info: json['info'] as String,
      hospital: json['hospital'] as String,
      charges: json['charges'] as String,
      expertise:
          (json['expertise'] as List<dynamic>).map((e) => e as String).toList(),
      preferredLang: (json['preferredLang'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  final String imgPath;
  final String name;
  final String yoe;
  final String type;
  final String info;
  final String hospital;
  final String charges;
  final List<String> expertise;
  final List<String> preferredLang;
}
