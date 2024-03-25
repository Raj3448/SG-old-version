class Member {
  Member({
    required this.name,
    required this.age,
    required this.gender,
    required this.relation,
    required this.mobileNo,
    required this.address,
    required this.hasCareSub,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'] as String,
      age: json['age'] as String,
      gender: json['gender'] as String,
      relation: json['relation'] as String,
      mobileNo: json['mobileNo'] as String,
      address: json['address'] as String,
      hasCareSub: json['hasCareSub'] as bool,
    );
  }
  final String name;
  final String age;
  final String gender;
  final String relation;
  final String mobileNo;
  final String address;
  final bool hasCareSub;
}
