import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:silver_genie/feature/book_services/model/doctor_model.dart';
import 'package:silver_genie/feature/book_services/model/time_slots_model.dart';

Future<List<DoctorModel>> fetchDocDetails() async {
  final response = await rootBundle.loadString('assets/json/doctor_info.json');
  final jsonData = json.decode(response) as List<dynamic>;
  return jsonData
      .map((json) => DoctorModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

Future<List<TimeSlotsModel>> fetchTimeSlots() async {
  final response = await rootBundle.loadString('assets/json/time_slots.json');
  final jsonData = json.decode(response) as List<dynamic>;
  return jsonData
      .map((json) => TimeSlotsModel.fromJson(json as Map<String, dynamic>))
      .toList();
}
