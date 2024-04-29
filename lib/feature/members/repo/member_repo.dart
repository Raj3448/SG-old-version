import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';


Future<List<Member>> fetchMembers() async {
  final response = await rootBundle.loadString('assets/json/members.json');
  final jsonData = json.decode(response) as List<dynamic>;
  return jsonData
      .map((json) => Member.fromJson(json as Map<String, dynamic>))
      .toList();
}


