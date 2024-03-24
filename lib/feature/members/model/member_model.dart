class Member {
  Member({
    required this.name,
    required this.relation,
    required this.hasCareSub,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'] as String,
      relation: json['relation'] as String,
      hasCareSub: json['hasCareSub'] as bool,
    );
  }
  final String name;
  final String relation;
  final bool hasCareSub;
}
